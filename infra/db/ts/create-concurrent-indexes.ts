import dotenv from "dotenv";
dotenv.config({ path: "infra/env/.env.local" });
import { Client } from "pg";

async function createConcurrentIndexes() {
  const client = new Client({
    host: process.env.PGHOST,
    port: parseInt(process.env.PGPORT || "5432", 10),
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    ssl: process.env.PGSSLMODE === "require" ? { rejectUnauthorized: false } : undefined,
  });

  try {
    await client.connect();
    console.log("🔗 Conectado a la base de datos");

    const indexes = [
      // Soft delete indexes (CRITICAL)
      {
        name: "idx_trn_projects_deleted_null",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_trn_projects_deleted_null ON projects.trn_projects(id) WHERE deleted_at IS NULL;",
        description: "Soft delete index for projects.trn_projects"
      },
      {
        name: "idx_mst_task_stages_deleted_null",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mst_task_stages_deleted_null ON tasks.mst_task_stages(id) WHERE deleted_at IS NULL;",
        description: "Soft delete index for tasks.mst_task_stages"
      },
      {
        name: "idx_mst_task_types_deleted_null",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_mst_task_types_deleted_null ON tasks.mst_task_types(id) WHERE deleted_at IS NULL;",
        description: "Soft delete index for tasks.mst_task_types"
      },

      // FK indexes (HIGH PRIORITY)
      {
        name: "idx_trn_projects_type_id",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_trn_projects_type_id ON projects.trn_projects(type_id);",
        description: "FK index for projects.trn_projects.type_id"
      },
      {
        name: "idx_trn_projects_owner_id",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_trn_projects_owner_id ON projects.trn_projects(owner_id);",
        description: "FK index for projects.trn_projects.owner_id"
      },
      {
        name: "idx_trn_projects_entity_id",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_trn_projects_entity_id ON projects.trn_projects(entity_id);",
        description: "FK index for projects.trn_projects.entity_id"
      },

      // Task assignments FK indexes
      {
        name: "idx_rel_task_assignments_task_id",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_rel_task_assignments_task_id ON tasks.rel_task_assignments(task_id);",
        description: "FK index for tasks.rel_task_assignments.task_id"
      },
      {
        name: "idx_rel_task_assignments_user_id",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_rel_task_assignments_user_id ON tasks.rel_task_assignments(user_id);",
        description: "FK index for tasks.rel_task_assignments.user_id"
      },

      // Audit field indexes (MEDIUM PRIORITY)
      {
        name: "idx_trn_projects_created_at",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_trn_projects_created_at ON projects.trn_projects(created_at);",
        description: "Audit timestamp index for projects.trn_projects.created_at"
      },
      {
        name: "idx_trn_projects_updated_at",
        sql: "CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_trn_projects_updated_at ON projects.trn_projects(updated_at);",
        description: "Audit timestamp index for projects.trn_projects.updated_at"
      }
    ];

    console.log("🏗️ Creando índices concurrentes...\n");

    for (let i = 0; i < indexes.length; i++) {
      const index = indexes[i];
      console.log(`📋 [${i + 1}/${indexes.length}] Creando: ${index.name}`);
      console.log(`   ${index.description}`);

      try {
        await client.query(index.sql);
        console.log(`   ✅ Éxito\n`);
      } catch (error: any) {
        console.log(`   ❌ Error: ${error.message}\n`);
        // Continue with next index instead of stopping
      }
    }

    // Verification queries
    console.log("🔍 Verificando índices creados...\n");

    const result = await client.query(`
      SELECT
        schemaname,
        tablename,
        indexname,
        indexdef
      FROM pg_indexes
      WHERE indexname LIKE '%deleted_null'
         OR indexname LIKE 'idx_trn_projects%'
         OR indexname LIKE 'idx_rel_task_assignments%'
      ORDER BY schemaname, tablename;
    `);

    console.log("📊 Índices de soft delete y FK creados:");
    console.table(result.rows);

    // Check for missing FK indexes
    const missingFKResult = await client.query(`
      SELECT
        tc.table_schema,
        tc.table_name,
        kcu.column_name,
        ccu.table_schema AS foreign_table_schema,
        ccu.table_name AS foreign_table_name
      FROM information_schema.table_constraints AS tc
      JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name
      JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
      WHERE tc.constraint_type = 'FOREIGN KEY'
      AND tc.table_schema NOT IN ('pg_catalog', 'information_schema')
      AND NOT EXISTS (
        SELECT 1 FROM pg_indexes pi
        WHERE pi.schemaname = tc.table_schema
          AND pi.tablename = tc.table_name
          AND pi.indexdef LIKE '%' || kcu.column_name || '%'
      );
    `);

    if (missingFKResult.rows.length === 0) {
      console.log("🎉 ¡Excelente! No hay FKs sin índices.");
    } else {
      console.log("⚠️ FKs sin índices encontrados:");
      console.table(missingFKResult.rows);
    }

    console.log("\n🏁 Creación de índices concurrentes completada!");

  } catch (error: any) {
    console.error("❌ Error general:", error.message);
    process.exit(1);
  } finally {
    await client.end();
  }
}

createConcurrentIndexes();



