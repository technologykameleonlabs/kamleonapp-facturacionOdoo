#!/usr/bin/env ts-node

/**
 * Index Optimizer for Kameleon App Database
 * Automatically creates optimal indexes based on query patterns and usage analysis
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

interface IndexDefinition {
  name: string;
  table: string;
  columns: string[];
  where_clause?: string;
  type?: 'btree' | 'gin' | 'gist' | 'hash';
  unique?: boolean;
  rationale: string;
  priority: 'CRITICAL' | 'HIGH' | 'MEDIUM' | 'LOW';
}

interface OptimizationResult {
  created_indexes: string[];
  skipped_indexes: string[];
  errors: string[];
  recommendations: string[];
}

class IndexOptimizer {
  private client: SupabaseClient;
  private dryRun: boolean;

  constructor(client: SupabaseClient, dryRun = false) {
    this.client = client;
    this.dryRun = dryRun;
  }

  async optimizeIndexes(): Promise<OptimizationResult> {
    console.log('🔧 Starting index optimization for Kameleon App...\n');

    const result: OptimizationResult = {
      created_indexes: [],
      skipped_indexes: [],
      errors: [],
      recommendations: []
    };

    // Define critical indexes for Kameleon App
    const indexesToCreate: IndexDefinition[] = [
      // CRITICAL: Foreign Key indexes
      {
        name: 'idx_projects_org_id',
        table: 'projects.trn_projects',
        columns: ['org_id'],
        rationale: 'FK index for tenant isolation queries',
        priority: 'CRITICAL'
      },
      {
        name: 'idx_tasks_project_id',
        table: 'projects.trn_tasks',
        columns: ['project_id'],
        rationale: 'FK index for project-task relationships',
        priority: 'CRITICAL'
      },
      {
        name: 'idx_tasks_org_id',
        table: 'projects.trn_tasks',
        columns: ['org_id'],
        rationale: 'FK index for tenant isolation in tasks',
        priority: 'CRITICAL'
      },

      // HIGH: Dashboard optimization indexes
      {
        name: 'idx_tasks_dashboard',
        table: 'projects.trn_tasks',
        columns: ['org_id', 'project_id', 'status', 'priority', 'due_date'],
        where_clause: 'deleted_at IS NULL',
        rationale: 'Composite index for task dashboard queries',
        priority: 'HIGH'
      },
      {
        name: 'idx_projects_dashboard',
        table: 'projects.trn_projects',
        columns: ['org_id', 'status', 'priority', 'deadline_at'],
        where_clause: 'deleted_at IS NULL',
        rationale: 'Composite index for project dashboard queries',
        priority: 'HIGH'
      },

      // HIGH: User lookup indexes
      {
        name: 'idx_users_email_ci',
        table: 'base.mst_users',
        columns: ['lower(email)'],
        where_clause: 'deleted_at IS NULL',
        unique: true,
        rationale: 'Case-insensitive unique index for email authentication',
        priority: 'HIGH'
      },

      // MEDIUM: Assignment optimization
      {
        name: 'idx_assignments_active',
        table: 'tasks.trn_assignments',
        columns: ['user_id', 'task_id', 'assigned_at'],
        where_clause: 'unassigned_at IS NULL',
        rationale: 'Index for active user assignments lookup',
        priority: 'MEDIUM'
      },

      // MEDIUM: Audit log optimization
      {
        name: 'idx_audit_recent',
        table: 'base.log_audit',
        columns: ['created_at DESC', 'user_id', 'action'],
        where_clause: "created_at >= CURRENT_DATE - INTERVAL '90 days'",
        rationale: 'Partial index for recent audit log queries',
        priority: 'MEDIUM'
      },

      // LOW: JSONB indexes (if extension available)
      {
        name: 'idx_tasks_metadata_gin',
        table: 'projects.trn_tasks',
        columns: ['metadata'],
        type: 'gin',
        rationale: 'GIN index for JSONB metadata queries',
        priority: 'LOW'
      }
    ];

    // Check if pg_trgm extension is available for text search
    const hasPgTrgm = await this.checkExtension('pg_trgm');
    if (hasPgTrgm) {
      indexesToCreate.push({
        name: 'idx_tasks_search_trgm',
        table: 'projects.trn_tasks',
        columns: ['title', 'description'],
        type: 'gin',
        rationale: 'Trigram index for task search functionality',
        priority: 'MEDIUM'
      });
    }

    // Process each index
    for (const indexDef of indexesToCreate) {
      try {
        const created = await this.createIndexIfNotExists(indexDef);
        if (created) {
          result.created_indexes.push(indexDef.name);
          console.log(`✅ Created index: ${indexDef.name} (${indexDef.priority})`);
        } else {
          result.skipped_indexes.push(indexDef.name);
          console.log(`⏭️ Skipped existing index: ${indexDef.name}`);
        }
      } catch (error) {
        const errorMsg = `Failed to create index ${indexDef.name}: ${error}`;
        result.errors.push(errorMsg);
        console.error(`❌ ${errorMsg}`);
      }
    }

    // Generate recommendations
    result.recommendations = await this.generateRecommendations();

    console.log('\n📊 Optimization Summary:');
    console.log(`✅ Created: ${result.created_indexes.length} indexes`);
    console.log(`⏭️ Skipped: ${result.skipped_indexes.length} indexes`);
    console.log(`❌ Errors: ${result.errors.length} indexes`);

    if (result.recommendations.length > 0) {
      console.log('\n🎯 Additional Recommendations:');
      result.recommendations.forEach((rec, i) => console.log(`${i + 1}. ${rec}`));
    }

    return result;
  }

  private async createIndexIfNotExists(indexDef: IndexDefinition): Promise<boolean> {
    // Check if index already exists
    const { data: existingIndex, error: checkError } = await this.client.rpc('execute_sql', {
      sql: `
        SELECT 1 FROM pg_indexes
        WHERE schemaname = $1
          AND tablename = $2
          AND indexname = $3
      `,
      params: [indexDef.table.split('.')[0], indexDef.table.split('.')[1], indexDef.name]
    });

    if (checkError) {
      throw new Error(`Failed to check existing index: ${checkError.message}`);
    }

    if (existingIndex && existingIndex.length > 0) {
      return false; // Index already exists
    }

    // Build CREATE INDEX statement
    let sql = `CREATE ${indexDef.unique ? 'UNIQUE ' : ''}INDEX CONCURRENTLY IF NOT EXISTS ${indexDef.name}`;

    if (indexDef.type && indexDef.type !== 'btree') {
      sql += ` USING ${indexDef.type}`;
    }

    sql += ` ON ${indexDef.table} (`;

    // Handle different column formats
    const columns = indexDef.columns.map(col => {
      if (col.includes('(') && col.includes(')')) {
        return col; // Already formatted (e.g., lower(email))
      }
      return col;
    });

    sql += columns.join(', ');
    sql += ')';

    if (indexDef.where_clause) {
      sql += ` WHERE ${indexDef.where_clause}`;
    }

    // Execute index creation (unless dry run)
    if (!this.dryRun) {
      const { error: createError } = await this.client.rpc('execute_sql', { sql });

      if (createError) {
        throw new Error(`Failed to create index: ${createError.message}`);
      }
    } else {
      console.log(`🔍 DRY RUN: Would create index with SQL: ${sql}`);
    }

    return true;
  }

  private async checkExtension(extensionName: string): Promise<boolean> {
    const { data, error } = await this.client.rpc('execute_sql', {
      sql: 'SELECT 1 FROM pg_extension WHERE extname = $1',
      params: [extensionName]
    });

    return !error && data && data.length > 0;
  }

  private async generateRecommendations(): Promise<string[]> {
    const recommendations: string[] = [];

    // Check for missing FK indexes
    const { data: missingFKs, error: fkError } = await this.client.rpc('execute_sql', {
      sql: `
        SELECT COUNT(*) as count
        FROM (
          SELECT conrelid::regclass AS table, a.attname AS fk_col
          FROM pg_constraint c
          JOIN pg_attribute a ON a.attrelid=c.conrelid AND a.attnum = ANY(c.conkey)
          LEFT JOIN pg_index i ON i.indrelid=c.conrelid AND i.indkey @> c.conkey
          WHERE c.contype='f' AND i.indrelid IS NULL
            AND conrelid::regclass::text NOT LIKE 'pg_%'
        ) missing
      `
    });

    if (!fkError && missingFKs && missingFKs[0]?.count > 0) {
      recommendations.push(`Create indexes on ${missingFKs[0].count} foreign key columns that lack them`);
    }

    // Check for unused indexes
    const { data: unusedIndexes, error: unusedError } = await this.client.rpc('execute_sql', {
      sql: `
        SELECT COUNT(*) as count
        FROM pg_stat_user_indexes
        WHERE idx_scan = 0 AND seq_scan > 100
          AND schemaname NOT IN ('pg_catalog', 'information_schema')
      `
    });

    if (!unusedError && unusedIndexes && unusedIndexes[0]?.count > 0) {
      recommendations.push(`Review ${unusedIndexes[0].count} potentially unused indexes for removal`);
    }

    // General recommendations
    recommendations.push('Run ANALYZE on tables after index creation to update statistics');
    recommendations.push('Monitor index usage with pg_stat_user_indexes after deployment');
    recommendations.push('Consider partitioning large tables (>1M rows) for better performance');

    return recommendations;
  }

  async cleanupUnusedIndexes(): Promise<{ removed: string[], kept: string[] }> {
    console.log('🧹 Analyzing unused indexes for cleanup...\n');

    const result = { removed: [], kept: [] };

    // Find potentially unused indexes (no scans, but table has sequential scans)
    const { data: unusedIndexes, error } = await this.client.rpc('execute_sql', {
      sql: `
        SELECT
          schemaname,
          tablename,
          indexname,
          idx_scan,
          seq_scan,
          pg_size_pretty(pg_relation_size(quote_ident(schemaname)||'.'||quote_ident(indexname))) as size
        FROM pg_stat_user_indexes
        WHERE idx_scan = 0
          AND seq_scan > 100
          AND schemaname NOT IN ('pg_catalog', 'information_schema')
          AND indexname LIKE 'idx_%'
        ORDER BY pg_relation_size(quote_ident(schemaname)||'.'||quote_ident(indexname)) DESC
      `
    });

    if (error) {
      throw new Error(`Failed to analyze unused indexes: ${error.message}`);
    }

    if (!unusedIndexes || unusedIndexes.length === 0) {
      console.log('✅ No unused indexes found');
      return result;
    }

    console.log(`Found ${unusedIndexes.length} potentially unused indexes:`);

    for (const index of unusedIndexes) {
      console.log(`  ${index.schemaname}.${index.indexname} (${index.size}) - 0 scans, ${index.seq_scan} table scans`);

      // In production, you might want to:
      // 1. Monitor for a period before dropping
      // 2. Get confirmation before dropping
      // 3. Have a rollback plan

      result.kept.push(index.indexname); // For now, just report - don't auto-drop
    }

    console.log('\n⚠️ Index cleanup requires manual review. Consider:');
    console.log('  1. Monitor unused indexes for a week before dropping');
    console.log('  2. Ensure no application code relies on them implicitly');
    console.log('  3. Have a DROP INDEX script ready for rollback');

    return result;
  }
}

// CLI interface
async function main() {
  const dryRun = process.argv.includes('--dry-run');
  const command = process.argv[2];

  if (dryRun) {
    console.log('🔍 DRY RUN MODE: No indexes will be created');
  }

  const optimizer = new IndexOptimizer(supabase, dryRun);

  switch (command) {
    case 'optimize':
      await optimizer.optimizeIndexes();
      break;
    case 'cleanup':
      await optimizer.cleanupUnusedIndexes();
      break;
    default:
      console.log('Usage: ts-node index-optimizer.ts [optimize|cleanup] [--dry-run]');
      console.log('  optimize: Create optimal indexes for Kameleon App');
      console.log('  cleanup: Analyze unused indexes (does not drop them)');
      console.log('  --dry-run: Show what would be done without executing');
      process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main().catch(console.error);
}

export { IndexOptimizer, IndexDefinition, OptimizationResult };
