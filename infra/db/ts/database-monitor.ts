#!/usr/bin/env ts-node

/**
 * Database Monitor for Kameleon App
 * Real-time monitoring of database health, performance, and security
 */

import { createClient, SupabaseClient } from '@supabase/supabase-js';

// Configuration
const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_ROLE = process.env.SUPABASE_SERVICE_ROLE;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE) {
  console.error('Missing Supabase environment variables');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE, {
  db: { schema: 'public' }
});

interface DatabaseMetrics {
  timestamp: string;
  connections: {
    active: number;
    idle: number;
    total: number;
  };
  performance: {
    cache_hit_ratio: number;
    avg_query_time: number;
    slow_queries_count: number;
  };
  storage: {
    total_size: string;
    largest_tables: Array<{ table: string; size: string; rows: number }>;
  };
  security: {
    rls_coverage: number;
    unprotected_tables: string[];
  };
  alerts: string[];
}

class DatabaseMonitor {
  private client: SupabaseClient;
  private intervalId?: NodeJS.Timeout;

  constructor(client: SupabaseClient) {
    this.client = client;
  }

  async getCurrentMetrics(): Promise<DatabaseMetrics> {
    const metrics: DatabaseMetrics = {
      timestamp: new Date().toISOString(),
      connections: await this.getConnectionStats(),
      performance: await this.getPerformanceStats(),
      storage: await this.getStorageStats(),
      security: await this.getSecurityStats(),
      alerts: []
    };

    // Generate alerts based on metrics
    metrics.alerts = this.generateAlerts(metrics);

    return metrics;
  }

  private async getConnectionStats() {
    try {
      const { data, error } = await this.client.rpc('execute_sql', {
        sql: `
          SELECT
            COUNT(*) FILTER (WHERE state = 'active') as active,
            COUNT(*) FILTER (WHERE state = 'idle') as idle,
            COUNT(*) as total
          FROM pg_stat_activity
          WHERE datname = current_database()
        `
      });

      if (error || !data || data.length === 0) {
        return { active: 0, idle: 0, total: 0 };
      }

      return {
        active: data[0].active || 0,
        idle: data[0].idle || 0,
        total: data[0].total || 0
      };
    } catch {
      return { active: 0, idle: 0, total: 0 };
    }
  }

  private async getPerformanceStats() {
    try {
      // Cache hit ratio
      const { data: cacheData } = await this.client.rpc('execute_sql', {
        sql: `
          SELECT
            ROUND(
              100 * sum(blks_hit)::numeric / (sum(blks_hit) + sum(blks_read)), 2
            ) as cache_hit_ratio
          FROM pg_stat_database
          WHERE datname = current_database()
        `
      });

      // Query performance (if pg_stat_statements is available)
      const { data: queryData } = await this.client.rpc('execute_sql', {
        sql: `
          SELECT
            COALESCE(AVG(mean_time), 0) as avg_query_time,
            COUNT(*) FILTER (WHERE mean_time > 1000) as slow_queries_count
          FROM pg_stat_statements
          WHERE dbid = (SELECT oid FROM pg_database WHERE datname = current_database())
            AND calls > 10
        `
      });

      return {
        cache_hit_ratio: cacheData?.[0]?.cache_hit_ratio || 0,
        avg_query_time: queryData?.[0]?.avg_query_time || 0,
        slow_queries_count: queryData?.[0]?.slow_queries_count || 0
      };
    } catch {
      return {
        cache_hit_ratio: 0,
        avg_query_time: 0,
        slow_queries_count: 0
      };
    }
  }

  private async getStorageStats() {
    try {
      const { data, error } = await this.client.rpc('execute_sql', {
        sql: `
          SELECT
            schemaname || '.' || tablename as table,
            pg_size_pretty(pg_total_relation_size(quote_ident(schemaname)||'.'||quote_ident(tablename))) as size,
            n_live_tup as rows
          FROM pg_stat_user_tables
          WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
          ORDER BY pg_total_relation_size(quote_ident(schemaname)||'.'||quote_ident(tablename)) DESC
          LIMIT 5
        `
      });

      const largest_tables = data || [];
      const total_size_bytes = largest_tables.reduce((sum, table) => {
        // Rough estimation - in production you'd use pg_database_size()
        return sum + (table.rows || 0) * 100; // Rough row size estimate
      }, 0);

      return {
        total_size: `${(total_size_bytes / 1024 / 1024).toFixed(2)} MB`,
        largest_tables
      };
    } catch {
      return {
        total_size: 'Unknown',
        largest_tables: []
      };
    }
  }

  private async getSecurityStats() {
    try {
      const { data, error } = await this.client.rpc('execute_sql', {
        sql: `
          SELECT
            COUNT(*) as total_tables,
            COUNT(CASE WHEN rowsecurity THEN 1 END) as tables_with_rls,
            ARRAY_AGG(
              CASE WHEN NOT rowsecurity THEN schemaname || '.' || tablename END
            ) FILTER (WHERE NOT rowsecurity) as unprotected_tables
          FROM pg_tables
          WHERE schemaname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
        `
      });

      if (error || !data || data.length === 0) {
        return { rls_coverage: 0, unprotected_tables: [] };
      }

      const total_tables = data[0].total_tables || 0;
      const tables_with_rls = data[0].tables_with_rls || 0;
      const rls_coverage = total_tables > 0 ? (tables_with_rls / total_tables) * 100 : 0;

      return {
        rls_coverage,
        unprotected_tables: data[0].unprotected_tables || []
      };
    } catch {
      return { rls_coverage: 0, unprotected_tables: [] };
    }
  }

  private generateAlerts(metrics: DatabaseMetrics): string[] {
    const alerts: string[] = [];

    // Connection alerts
    if (metrics.connections.active > 50) {
      alerts.push(`HIGH: ${metrics.connections.active} active connections (potential bottleneck)`);
    }

    // Performance alerts
    if (metrics.performance.cache_hit_ratio < 90) {
      alerts.push(`MEDIUM: Cache hit ratio is ${metrics.performance.cache_hit_ratio}% (should be >95%)`);
    }

    if (metrics.performance.slow_queries_count > 10) {
      alerts.push(`HIGH: ${metrics.performance.slow_queries_count} slow queries detected`);
    }

    // Security alerts
    if (metrics.security.rls_coverage < 90) {
      alerts.push(`CRITICAL: Only ${metrics.security.rls_coverage.toFixed(1)}% tables have RLS enabled`);
    }

    if (metrics.security.unprotected_tables.length > 0) {
      alerts.push(`CRITICAL: ${metrics.security.unprotected_tables.length} tables lack RLS protection`);
    }

    return alerts;
  }

  async displayMetrics(): Promise<void> {
    const metrics = await this.getCurrentMetrics();

    console.clear();
    console.log('📊 Kameleon App Database Monitor');
    console.log('='.repeat(50));
    console.log(`📅 ${new Date(metrics.timestamp).toLocaleString()}\n`);

    // Connections
    console.log('🔗 Database Connections:');
    console.log(`  Active: ${metrics.connections.active}`);
    console.log(`  Idle: ${metrics.connections.idle}`);
    console.log(`  Total: ${metrics.connections.total}\n`);

    // Performance
    console.log('⚡ Performance Metrics:');
    console.log(`  Cache Hit Ratio: ${metrics.performance.cache_hit_ratio}%`);
    console.log(`  Avg Query Time: ${metrics.performance.avg_query_time.toFixed(2)}ms`);
    console.log(`  Slow Queries: ${metrics.performance.slow_queries_count}\n`);

    // Storage
    console.log('💾 Storage Overview:');
    console.log(`  Total Size: ${metrics.storage.total_size}`);
    console.log('  Largest Tables:');
    metrics.storage.largest_tables.slice(0, 3).forEach(table => {
      console.log(`    ${table.table}: ${table.size} (${table.rows.toLocaleString()} rows)`);
    });
    console.log('');

    // Security
    console.log('🔒 Security Status:');
    console.log(`  RLS Coverage: ${metrics.security.rls_coverage.toFixed(1)}%`);
    if (metrics.security.unprotected_tables.length > 0) {
      console.log(`  ⚠️ Unprotected Tables: ${metrics.security.unprotected_tables.length}`);
    }
    console.log('');

    // Alerts
    if (metrics.alerts.length > 0) {
      console.log('🚨 Active Alerts:');
      metrics.alerts.forEach(alert => console.log(`  ${alert}`));
    } else {
      console.log('✅ No active alerts');
    }
  }

  startMonitoring(intervalSeconds = 30): void {
    console.log(`🔄 Starting database monitoring (updates every ${intervalSeconds}s)...`);
    console.log('Press Ctrl+C to stop\n');

    // Initial display
    this.displayMetrics();

    // Set up interval
    this.intervalId = setInterval(async () => {
      try {
        await this.displayMetrics();
      } catch (error) {
        console.error('❌ Error updating metrics:', error);
      }
    }, intervalSeconds * 1000);

    // Handle graceful shutdown
    process.on('SIGINT', () => {
      console.log('\n🛑 Stopping database monitor...');
      if (this.intervalId) {
        clearInterval(this.intervalId);
      }
      process.exit(0);
    });
  }

  async exportMetrics(filename?: string): Promise<void> {
    const metrics = await this.getCurrentMetrics();
    const exportPath = filename || `database-metrics-${Date.now()}.json`;

    const fs = require('fs');
    fs.writeFileSync(exportPath, JSON.stringify(metrics, null, 2));

    console.log(`📄 Metrics exported to: ${exportPath}`);
  }
}

// CLI interface
async function main() {
  const monitor = new DatabaseMonitor(supabase);
  const command = process.argv[2];

  switch (command) {
    case 'monitor':
      const interval = parseInt(process.argv[3]) || 30;
      monitor.startMonitoring(interval);
      break;
    case 'snapshot':
      await monitor.displayMetrics();
      break;
    case 'export':
      const filename = process.argv[3];
      await monitor.exportMetrics(filename);
      break;
    default:
      console.log('Usage: ts-node database-monitor.ts [monitor|snapshot|export] [interval_seconds|filename]');
      console.log('  monitor [seconds]: Start real-time monitoring (default 30s)');
      console.log('  snapshot: Display current metrics once');
      console.log('  export [filename]: Export metrics to JSON file');
      process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main().catch(console.error);
}

export { DatabaseMonitor, DatabaseMetrics };
