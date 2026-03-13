#!/usr/bin/env ts-node

/**
 * Performance Analyzer for Kameleon App Database
 * Analyzes query performance, suggests optimizations, and monitors database health
 */

import { createClient, SupabaseClient } from '@supabase/supabase-js';
import * as fs from 'fs';
import * as path from 'path';

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

interface QueryPerformance {
  query: string;
  calls: number;
  total_time: number;
  mean_time: number;
  rows: number;
  performance_category: 'VERY_SLOW' | 'SLOW' | 'MODERATE' | 'FAST';
}

interface IndexRecommendation {
  table: string;
  recommended_index: string;
  rationale: string;
  expected_impact: 'HIGH' | 'MEDIUM' | 'LOW';
}

interface PerformanceReport {
  timestamp: string;
  database_health: {
    total_tables: number;
    tables_with_rls: number;
    rls_coverage_percentage: number;
  };
  index_analysis: {
    total_indexes: number;
    unused_indexes: number;
    missing_fk_indexes: number;
    recommendations: IndexRecommendation[];
  };
  query_performance: {
    slow_queries_count: number;
    top_slow_queries: QueryPerformance[];
    avg_query_time: number;
  };
  recommendations: string[];
}

class PerformanceAnalyzer {
  private client: SupabaseClient;

  constructor(client: SupabaseClient) {
    this.client = client;
  }

  async analyzeDatabasePerformance(): Promise<PerformanceReport> {
    console.log('🔍 Starting comprehensive database performance analysis...\n');

    const report: PerformanceReport = {
      timestamp: new Date().toISOString(),
      database_health: await this.analyzeDatabaseHealth(),
      index_analysis: await this.analyzeIndexes(),
      query_performance: await this.analyzeQueryPerformance(),
      recommendations: []
    };

    // Generate recommendations based on analysis
    report.recommendations = await this.generateRecommendations(report);

    return report;
  }

  private async analyzeDatabaseHealth() {
    console.log('📊 Analyzing database health...');

    // Count tables and RLS coverage
    const { data: tablesData, error: tablesError } = await this.client.rpc('execute_sql', {
      sql: `
        SELECT
          COUNT(*) as total_tables,
          COUNT(CASE WHEN rowsecurity THEN 1 END) as tables_with_rls
        FROM pg_tables
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
      `
    });

    if (tablesError) {
      console.warn('Could not analyze table RLS status:', tablesError);
      return { total_tables: 0, tables_with_rls: 0, rls_coverage_percentage: 0 };
    }

    const total_tables = tablesData?.[0]?.total_tables || 0;
    const tables_with_rls = tablesData?.[0]?.tables_with_rls || 0;
    const rls_coverage_percentage = total_tables > 0 ? (tables_with_rls / total_tables) * 100 : 0;

    console.log(`✅ Database health: ${tables_with_rls}/${total_tables} tables with RLS (${rls_coverage_percentage.toFixed(1)}%)`);

    return {
      total_tables,
      tables_with_rls,
      rls_coverage_percentage
    };
  }

  private async analyzeIndexes() {
    console.log('🔍 Analyzing indexes...');

    // Get index statistics
    const { data: indexData, error: indexError } = await this.client.rpc('execute_sql', {
      sql: `
        SELECT
          COUNT(*) as total_indexes,
          COUNT(CASE WHEN idx_scan = 0 AND seq_scan > 100 THEN 1 END) as potentially_unused
        FROM pg_stat_user_indexes
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
      `
    });

    // Find missing FK indexes
    const { data: fkData, error: fkError } = await this.client.rpc('execute_sql', {
      sql: `
        SELECT COUNT(*) as missing_fk_indexes
        FROM (
          SELECT conrelid::regclass AS table, a.attname AS fk_col
          FROM pg_constraint c
          JOIN pg_attribute a ON a.attrelid=c.conrelid AND a.attnum = ANY(c.conkey)
          LEFT JOIN pg_index i ON i.indrelid=c.conrelid AND i.indkey @> c.conkey
          WHERE c.contype='f' AND i.indrelid IS NULL
        ) missing_indexes
      `
    });

    const total_indexes = indexData?.[0]?.total_indexes || 0;
    const unused_indexes = indexData?.[0]?.potentially_unused || 0;
    const missing_fk_indexes = fkData?.[0]?.missing_fk_indexes || 0;

    console.log(`✅ Index analysis: ${total_indexes} total, ${unused_indexes} potentially unused, ${missing_fk_indexes} missing FK indexes`);

    // Generate recommendations
    const recommendations = await this.generateIndexRecommendations();

    return {
      total_indexes,
      unused_indexes,
      missing_fk_indexes,
      recommendations
    };
  }

  private async analyzeQueryPerformance() {
    console.log('⚡ Analyzing query performance...');

    // Check if pg_stat_statements is available
    const { data: extData } = await this.client.rpc('execute_sql', {
      sql: "SELECT 1 FROM pg_extension WHERE extname = 'pg_stat_statements'"
    });

    if (!extData || extData.length === 0) {
      console.warn('⚠️ pg_stat_statements extension not available. Install for detailed query analysis.');
      return {
        slow_queries_count: 0,
        top_slow_queries: [],
        avg_query_time: 0
      };
    }

    // Get slow queries
    const { data: queryData, error: queryError } = await this.client.rpc('execute_sql', {
      sql: `
        SELECT
          query,
          calls,
          total_time,
          mean_time,
          rows,
          CASE
            WHEN mean_time > 10000 THEN 'VERY_SLOW'
            WHEN mean_time > 1000 THEN 'SLOW'
            WHEN mean_time > 100 THEN 'MODERATE'
            ELSE 'FAST'
          END as performance_category
        FROM pg_stat_statements
        WHERE dbid = (SELECT oid FROM pg_database WHERE datname = current_database())
          AND mean_time > 100
        ORDER BY mean_time DESC
        LIMIT 10
      `
    });

    const slow_queries = queryData || [];
    const slow_queries_count = slow_queries.length;
    const avg_query_time = slow_queries.length > 0
      ? slow_queries.reduce((sum: number, q: QueryPerformance) => sum + q.mean_time, 0) / slow_queries.length
      : 0;

    console.log(`✅ Query performance: ${slow_queries_count} slow queries found, avg time: ${avg_query_time.toFixed(2)}ms`);

    return {
      slow_queries_count,
      top_slow_queries: slow_queries,
      avg_query_time
    };
  }

  private async generateIndexRecommendations(): Promise<IndexRecommendation[]> {
    const recommendations: IndexRecommendation[] = [];

    // Common query pattern recommendations for Kameleon App
    recommendations.push({
      table: 'projects.trn_tasks',
      recommended_index: 'CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_tasks_dashboard ON projects.trn_tasks (org_id, project_id, status, priority, due_date) WHERE deleted_at IS NULL;',
      rationale: 'Optimizes dashboard queries filtering tasks by organization, project, and status',
      expected_impact: 'HIGH'
    });

    recommendations.push({
      table: 'tasks.trn_assignments',
      recommended_index: 'CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_assignments_active ON tasks.trn_assignments (user_id, task_id, assigned_at) WHERE unassigned_at IS NULL;',
      rationale: 'Speeds up queries for active user assignments',
      expected_impact: 'MEDIUM'
    });

    recommendations.push({
      table: 'base.mst_users',
      recommended_index: 'CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS idx_users_email_ci ON base.mst_users (lower(email)) WHERE deleted_at IS NULL;',
      rationale: 'Enables fast case-insensitive email lookups for authentication',
      expected_impact: 'HIGH'
    });

    return recommendations;
  }

  private async generateRecommendations(report: PerformanceReport): Promise<string[]> {
    const recommendations: string[] = [];

    // RLS coverage recommendations
    if (report.database_health.rls_coverage_percentage < 90) {
      recommendations.push(`CRITICAL: Only ${report.database_health.rls_coverage_percentage.toFixed(1)}% of tables have RLS enabled. Enable RLS on all user-facing tables.`);
    }

    // Index recommendations
    if (report.index_analysis.missing_fk_indexes > 0) {
      recommendations.push(`HIGH: ${report.index_analysis.missing_fk_indexes} foreign key columns lack indexes. Create indexes on all FK columns used in JOINs.`);
    }

    if (report.index_analysis.unused_indexes > 5) {
      recommendations.push(`MEDIUM: ${report.index_analysis.unused_indexes} indexes appear unused. Monitor and consider dropping to reduce maintenance overhead.`);
    }

    // Query performance recommendations
    if (report.query_performance.slow_queries_count > 0) {
      recommendations.push(`HIGH: ${report.query_performance.slow_queries_count} slow queries detected (avg ${report.query_performance.avg_query_time.toFixed(2)}ms). Review query optimization and add appropriate indexes.`);
    }

    // General recommendations
    recommendations.push('Consider enabling pg_stat_statements extension for detailed query analysis.');
    recommendations.push('Run ANALYZE on tables after major data changes to update statistics.');
    recommendations.push('Monitor autovacuum settings for large tables to prevent bloat.');

    return recommendations;
  }

  async generateReport(): Promise<void> {
    try {
      const report = await this.analyzeDatabasePerformance();

      // Generate markdown report
      const markdownReport = this.generateMarkdownReport(report);

      // Save to file
      const reportPath = path.join(process.cwd(), '03-poc/0301-database', 'performance-report.md');
      fs.writeFileSync(reportPath, markdownReport);

      console.log(`\n📄 Performance report saved to: ${reportPath}`);
      console.log('\n🎯 Top Recommendations:');
      report.recommendations.slice(0, 5).forEach((rec, i) => {
        console.log(`${i + 1}. ${rec}`);
      });

    } catch (error) {
      console.error('❌ Error generating performance report:', error);
      process.exit(1);
    }
  }

  private generateMarkdownReport(report: PerformanceReport): string {
    return `# 🏥 Kameleon App Database Performance Report

**Generated:** ${report.timestamp}

## 📊 Database Health Overview

- **Total Tables:** ${report.database_health.total_tables}
- **Tables with RLS:** ${report.database_health.tables_with_rls}
- **RLS Coverage:** ${report.database_health.rls_coverage_percentage.toFixed(1)}%

## 🔍 Index Analysis

- **Total Indexes:** ${report.index_analysis.total_indexes}
- **Potentially Unused:** ${report.index_analysis.unused_indexes}
- **Missing FK Indexes:** ${report.index_analysis.missing_fk_indexes}

### Recommended Indexes

${report.index_analysis.recommendations.map(rec => `
#### ${rec.table}
**Index:** \`${rec.recommended_index}\`
**Rationale:** ${rec.rationale}
**Expected Impact:** ${rec.expected_impact}
`).join('\n')}

## ⚡ Query Performance

- **Slow Queries:** ${report.query_performance.slow_queries_count}
- **Average Query Time:** ${report.query_performance.avg_query_time.toFixed(2)}ms

### Top Slow Queries

${report.query_performance.top_slow_queries.slice(0, 5).map((query, i) => `
${i + 1}. **${query.performance_category}** (${query.mean_time.toFixed(2)}ms avg, ${query.calls} calls)
   \`\`\`sql
   ${query.query.substring(0, 100)}${query.query.length > 100 ? '...' : ''}
   \`\`\`
`).join('\n')}

## 🎯 Recommendations

${report.recommendations.map((rec, i) => `${i + 1}. ${rec}`).join('\n')}

---
*Report generated by Kameleon App Performance Analyzer*
`;
  }
}

// CLI interface
async function main() {
  const analyzer = new PerformanceAnalyzer(supabase);

  const command = process.argv[2];

  switch (command) {
    case 'analyze':
      await analyzer.generateReport();
      break;
    case 'health':
      const report = await analyzer.analyzeDatabasePerformance();
      console.log(JSON.stringify(report.database_health, null, 2));
      break;
    default:
      console.log('Usage: ts-node performance-analyzer.ts [analyze|health]');
      console.log('  analyze: Generate full performance report');
      console.log('  health: Show database health summary');
      process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main().catch(console.error);
}

export { PerformanceAnalyzer, PerformanceReport };
