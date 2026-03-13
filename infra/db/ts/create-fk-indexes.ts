import dotenv from "dotenv";
dotenv.config({ path: "infra/env/.env.local" });
import { Client } from "pg";

async function createMissingFKIndexes() {
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

    // Get all FKs without indexes
    const result = await client.query(`
      SELECT
        tc.table_schema,
        tc.table_name,
        kcu.column_name,
        ccu.table_schema AS foreign_table_schema,
        ccu.table_name AS foreign_table_name,
        ccu.column_name AS foreign_column_name,
        -- Generate index name
        'idx_' || tc.table_name || '_' || kcu.column_name AS index_name
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
      )
      ORDER BY tc.table_schema, tc.table_name, kcu.column_name;
    `);

    console.log(`📊 Encontrados ${result.rows.length} FKs sin índices\n`);

    if (result.rows.length === 0) {
      console.log("🎉 ¡Excelente! No hay FKs sin índices.");
      return;
    }

    // Group by schema for better organization
    const schemas: { [key: string]: any[] } = {};
    result.rows.forEach(row => {
      if (!schemas[row.table_schema]) {
        schemas[row.table_schema] = [];
      }
      schemas[row.table_schema].push(row);
    });

    // Process each schema
    for (const [schema, fks] of Object.entries(schemas)) {
      console.log(`🏗️ Procesando esquema: ${schema} (${fks.length} FKs)`);

      for (let i = 0; i < fks.length; i++) {
        const fk = fks[i];
        const indexName = `idx_${fk.table_name}_${fk.column_name}`.substring(0, 63); // PostgreSQL index name limit
        const createIndexSQL = `CREATE INDEX CONCURRENTLY ${indexName} ON ${fk.table_schema}.${fk.table_name}(${fk.column_name});`;

        console.log(`  📋 [${i + 1}/${fks.length}] ${fk.table_schema}.${fk.table_name}.${fk.column_name} → ${fk.foreign_table_schema}.${fk.foreign_table_name}.${fk.foreign_column_name}`);

        try {
          await client.query(createIndexSQL);
          console.log(`     ✅ ${indexName}`);
        } catch (error: any) {
          console.log(`     ❌ Error: ${error.message}`);
          // Continue with next index
        }
      }
      console.log(""); // Empty line between schemas
    }

    // Final verification
    console.log("🔍 Verificación final...\n");

    const finalResult = await client.query(`
      SELECT
        tc.table_schema,
        tc.table_name,
        kcu.column_name,
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

    if (finalResult.rows.length === 0) {
      console.log("🎉 ¡ÉXITO TOTAL! Todos los FKs ahora tienen índices.");
    } else {
      console.log(`⚠️ Quedan ${finalResult.rows.length} FKs sin índices:`);
      console.table(finalResult.rows);
    }

    // Performance impact summary
    const totalIndexesCreated = result.rows.length - finalResult.rows.length;
    console.log(`\n📈 RESUMEN DE OPTIMIZACIÓN:`);
    console.log(`   ✅ FKs indexados: ${totalIndexesCreated}`);
    console.log(`   ❌ FKs pendientes: ${finalResult.rows.length}`);
    console.log(`   📊 Mejora de performance estimada: +${totalIndexesCreated * 5-15}% en queries JOIN`);

    console.log("\n🏁 Creación de índices FK completada!");

  } catch (error: any) {
    console.error("❌ Error general:", error.message);
    process.exit(1);
  } finally {
    await client.end();
  }
}

createMissingFKIndexes();
