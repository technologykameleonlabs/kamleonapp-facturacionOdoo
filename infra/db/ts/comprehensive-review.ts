import dotenv from "dotenv";
dotenv.config({ path: "infra/env/.env.local" });
import { Client } from "pg";
import fs from "fs/promises";

async function comprehensiveDatabaseReview() {
  console.log("🔍 INICIANDO REVISIÓN COMPREHENSIVA DE OPTIMIZACIÓN DE BASE DE DATOS\n");

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
    console.log("✅ Conectado a la base de datos");

    const results = {
      namingConventions: {},
      softDelete: {},
      auditFields: {},
      constraints: {},
      rlsPolicies: {},
      indexing: {},
      functions: {},
      extensions: {}
    };

    // 1. REVISIÓN DE CONVENCIONES DE NOMENCLATURA
    console.log("\n📋 1. VERIFICANDO CONVENCIONES DE NOMENCLATURA...");

    const namingResult = await client.query(`
      SELECT
        schemaname,
        tablename,
        CASE
          WHEN tablename LIKE 'mst_%' THEN 'MASTER'
          WHEN tablename LIKE 'trn_%' THEN 'TRANSACTION'
          WHEN tablename LIKE 'rel_%' THEN 'RELATION'
          WHEN tablename LIKE 'cfg_%' THEN 'CONFIG'
          WHEN tablename LIKE 'cat_%' THEN 'CATALOG'
          WHEN tablename LIKE 'evt_%' THEN 'EVENT'
          WHEN tablename LIKE 'log_%' THEN 'LOG'
          ELSE 'NO_PREFIX'
        END as prefix_type
      FROM pg_tables t
      WHERE t.schemaname IN ('analytics', 'approval', 'base', 'budgeting', 'masterdata', 'notifications', 'presence', 'progress', 'projects', 'tasks')
        AND t.tablename NOT LIKE 'pg_%'
      ORDER BY schemaname, tablename;
    `);

    results.namingConventions = {
      totalTables: namingResult.rows.length,
      violations: namingResult.rows.filter(r => r.prefix_type === 'NO_PREFIX').length,
      bySchema: namingResult.rows.reduce((acc, row) => {
        acc[row.schemaname] = acc[row.schemaname] || [];
        acc[row.schemaname].push(row);
        return acc;
      }, {})
    };

    console.log(`   📊 Total de tablas: ${results.namingConventions.totalTables}`);
    console.log(`   ⚠️  Violaciones: ${results.namingConventions.violations}`);

    // 2. REVISIÓN DE SOFT DELETE
    console.log("\n🗑️ 2. VERIFICANDO IMPLEMENTACIÓN DE SOFT DELETE...");

    const softDeleteResult = await client.query(`
      SELECT
        schemaname,
        tablename,
        CASE
          WHEN EXISTS (
            SELECT 1 FROM information_schema.columns c
            WHERE c.table_schema = t.schemaname
              AND c.table_name = t.tablename
              AND c.column_name = 'deleted_at'
          ) THEN '✅ IMPLEMENTED'
          ELSE '❌ MISSING'
        END as soft_delete_status,
        CASE
          WHEN tablename LIKE 'trn_%' THEN 'HIGH PRIORITY'
          WHEN tablename LIKE 'mst_%' THEN 'MEDIUM PRIORITY'
          ELSE 'LOW PRIORITY'
        END as priority
      FROM pg_tables t
      WHERE t.schemaname IN ('analytics', 'approval', 'base', 'budgeting', 'masterdata', 'notifications', 'presence', 'progress', 'projects', 'tasks')
        AND t.tablename NOT LIKE 'pg_%'
      ORDER BY
        CASE WHEN NOT EXISTS (
          SELECT 1 FROM information_schema.columns c
          WHERE c.table_schema = t.schemaname
            AND c.table_name = t.tablename
            AND c.column_name = 'deleted_at'
        ) THEN 1 ELSE 2 END,
        schemaname, tablename;
    `);

    results.softDelete = {
      totalTables: softDeleteResult.rows.length,
      implemented: softDeleteResult.rows.filter(r => r.soft_delete_status === '✅ IMPLEMENTED').length,
      missing: softDeleteResult.rows.filter(r => r.soft_delete_status === '❌ MISSING').length,
      byPriority: softDeleteResult.rows.reduce((acc, row) => {
        acc[row.priority] = acc[row.priority] || [];
        acc[row.priority].push(row);
        return acc;
      }, {})
    };

    console.log(`   📊 Tablas con soft delete: ${results.softDelete.implemented}/${results.softDelete.totalTables}`);
    console.log(`   ❌ Faltantes: ${results.softDelete.missing}`);

    // 3. REVISIÓN DE CAMPOS DE AUDITORÍA
    console.log("\n📝 3. VERIFICANDO CAMPOS DE AUDITORÍA...");

    const auditResult = await client.query(`
      SELECT
        t.schemaname,
        t.tablename,
        CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns c WHERE c.table_schema = t.schemaname AND c.table_name = t.tablename AND c.column_name = 'created_at') THEN '✅' ELSE '❌' END as created_at,
        CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns c WHERE c.table_schema = t.schemaname AND c.table_name = t.tablename AND c.column_name = 'updated_at') THEN '✅' ELSE '❌' END as updated_at,
        CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns c WHERE c.table_schema = t.schemaname AND c.table_name = t.tablename AND c.column_name = 'created_by') THEN '✅' ELSE '❌' END as created_by,
        CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns c WHERE c.table_schema = t.schemaname AND c.table_name = t.tablename AND c.column_name = 'updated_by') THEN '✅' ELSE '❌' END as updated_by
      FROM pg_tables t
      WHERE t.schemaname IN ('analytics', 'approval', 'base', 'budgeting', 'masterdata', 'notifications', 'presence', 'progress', 'projects', 'tasks')
        AND t.tablename NOT LIKE 'pg_%'
      ORDER BY schemaname, tablename;
    `);

    results.auditFields = {
      totalTables: auditResult.rows.length,
      complete: auditResult.rows.filter(r =>
        r.created_at === '✅' && r.updated_at === '✅' &&
        r.created_by === '✅' && r.updated_by === '✅'
      ).length,
      missingAny: auditResult.rows.filter(r =>
        r.created_at === '❌' || r.updated_at === '❌' ||
        r.created_by === '❌' || r.updated_by === '❌'
      ).length
    };

    console.log(`   📊 Auditoría completa: ${results.auditFields.complete}/${results.auditFields.totalTables}`);
    console.log(`   ⚠️  Con campos faltantes: ${results.auditFields.missingAny}`);

    // 4. REVISIÓN DE POLÍTICAS RLS
    console.log("\n🔒 4. VERIFICANDO POLÍTICAS RLS...");

    const rlsResult = await client.query(`
      SELECT
        schemaname,
        tablename,
        rowsecurity as rls_enabled,
        CASE WHEN rowsecurity THEN '✅ ENABLED' ELSE '❌ DISABLED' END as status,
        CASE
          WHEN tablename LIKE 'trn_%' THEN 'CRITICAL'
          WHEN tablename LIKE 'mst_%' THEN 'HIGH'
          ELSE 'MEDIUM'
        END as priority
      FROM pg_tables t
      WHERE t.schemaname IN ('analytics', 'approval', 'base', 'budgeting', 'masterdata', 'notifications', 'presence', 'progress', 'projects', 'tasks')
        AND t.tablename NOT LIKE 'pg_%'
      ORDER BY
        CASE WHEN NOT rowsecurity THEN 1 ELSE 2 END,
        CASE
          WHEN tablename LIKE 'trn_%' THEN 1
          WHEN tablename LIKE 'mst_%' THEN 2
          ELSE 3
        END,
        schemaname, tablename;
    `);

    results.rlsPolicies = {
      totalTables: rlsResult.rows.length,
      enabled: rlsResult.rows.filter(r => r.rls_enabled).length,
      disabled: rlsResult.rows.filter(r => !r.rls_enabled).length,
      byPriority: rlsResult.rows.reduce((acc, row) => {
        acc[row.priority] = acc[row.priority] || [];
        acc[row.priority].push(row);
        return acc;
      }, {})
    };

    console.log(`   📊 RLS habilitado: ${results.rlsPolicies.enabled}/${results.rlsPolicies.totalTables}`);
    console.log(`   ❌ Sin RLS: ${results.rlsPolicies.disabled}`);

    // 5. REVISIÓN DE ÍNDICES
    console.log("\n⚡ 5. VERIFICANDO ESTRATEGIA DE ÍNDICES...");

    const indexResult = await client.query(`
      SELECT
        schemaname,
        tablename,
        COUNT(*) as index_count
      FROM pg_indexes
      WHERE schemaname IN ('analytics', 'approval', 'base', 'budgeting', 'masterdata', 'notifications', 'presence', 'progress', 'projects', 'tasks')
      GROUP BY schemaname, tablename
      ORDER BY schemaname, tablename;
    `);

    results.indexing = {
      totalTables: results.namingConventions.totalTables,
      tablesWithIndexes: indexResult.rows.length,
      averageIndexesPerTable: indexResult.rows.length > 0 ?
        (indexResult.rows.reduce((sum, r) => sum + parseInt(r.index_count), 0) / indexResult.rows.length).toFixed(1) : 0,
      bySchema: indexResult.rows.reduce((acc, row) => {
        acc[row.schemaname] = acc[row.schemaname] || [];
        acc[row.schemaname].push(row);
        return acc;
      }, {})
    };

    console.log(`   📊 Tablas con índices: ${results.indexing.tablesWithIndexes}/${results.indexing.totalTables}`);
    console.log(`   📈 Promedio de índices por tabla: ${results.indexing.averageIndexesPerTable}`);

    // 6. VERIFICACIÓN DE EXTENSIONS
    console.log("\n🔧 6. VERIFICANDO EXTENSIONS INSTALADAS...");

    const extensionsResult = await client.query(`
      SELECT name, default_version, installed_version, comment
      FROM pg_available_extensions
      WHERE installed_version IS NOT NULL
      ORDER BY name;
    `);

    results.extensions = {
      installed: extensionsResult.rows.length,
      list: extensionsResult.rows
    };

    console.log(`   📦 Extensions instaladas: ${results.extensions.installed}`);
    console.table(extensionsResult.rows);

    // 7. ANÁLISIS DE FKs SIN ÍNDICES
    console.log("\n🔗 7. VERIFICANDO FKS SIN ÍNDICES...");

    const fkIndexResult = await client.query(`
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

    results.indexing.missingFKIndexes = fkIndexResult.rows.length;
    console.log(`   ❌ FKs sin índices: ${results.indexing.missingFKIndexes}`);

    // 8. GENERAR REPORTE FINAL
    console.log("\n📊 GENERANDO REPORTE FINAL DE REVISIÓN...\n");

    const finalReport = {
      timestamp: new Date().toISOString(),
      summary: {
        totalTables: results.namingConventions.totalTables,
        namingCompliance: `${results.namingConventions.totalTables - results.namingConventions.violations}/${results.namingConventions.totalTables}`,
        softDeleteCoverage: `${results.softDelete.implemented}/${results.softDelete.totalTables}`,
        auditFieldsComplete: `${results.auditFields.complete}/${results.auditFields.totalTables}`,
        rlsEnabled: `${results.rlsPolicies.enabled}/${results.rlsPolicies.totalTables}`,
        missingFKIndexes: results.indexing.missingFKIndexes,
        extensionsInstalled: results.extensions.installed
      },
      scores: {
        namingConventions: Math.round(((results.namingConventions.totalTables - results.namingConventions.violations) / results.namingConventions.totalTables) * 100),
        softDelete: Math.round((results.softDelete.implemented / results.softDelete.totalTables) * 100),
        auditFields: Math.round((results.auditFields.complete / results.auditFields.totalTables) * 100),
        rlsSecurity: Math.round((results.rlsPolicies.enabled / results.rlsPolicies.totalTables) * 100),
        indexing: results.indexing.missingFKIndexes === 0 ? 100 : Math.max(0, 100 - (results.indexing.missingFKIndexes * 5)),
        extensions: Math.min(100, results.extensions.installed * 10)
      },
      recommendations: [],
      criticalIssues: [],
      warnings: []
    };

    // Calcular score global
    finalReport.summary.overallScore = Math.round(
      (finalReport.scores.namingConventions * 0.1 +
       finalReport.scores.softDelete * 0.2 +
       finalReport.scores.auditFields * 0.15 +
       finalReport.scores.rlsSecurity * 0.25 +
       finalReport.scores.indexing * 0.2 +
       finalReport.scores.extensions * 0.1)
    );

    // Generar recomendaciones
    if (results.namingConventions.violations > 0) {
      finalReport.recommendations.push("Revisar y corregir convenciones de nomenclatura");
      finalReport.criticalIssues.push(`${results.namingConventions.violations} tablas sin prefijo obligatorio`);
    }

    if (results.softDelete.missing > 0) {
      finalReport.recommendations.push("Implementar soft delete faltante");
      finalReport.criticalIssues.push(`${results.softDelete.missing} tablas sin soft delete`);
    }

    if (results.auditFields.missingAny > 0) {
      finalReport.recommendations.push("Completar campos de auditoría faltantes");
      finalReport.warnings.push(`${results.auditFields.missingAny} tablas con auditoría incompleta`);
    }

    if (results.rlsPolicies.disabled > 0) {
      finalReport.recommendations.push("Implementar RLS faltante en tablas críticas");
      finalReport.criticalIssues.push(`${results.rlsPolicies.disabled} tablas sin RLS`);
    }

    if (results.indexing.missingFKIndexes > 0) {
      finalReport.recommendations.push("Crear índices faltantes en FKs");
      finalReport.warnings.push(`${results.indexing.missingFKIndexes} FKs sin índices de performance`);
    }

    // Mostrar resultados
    console.log("🎯 RESULTADOS DE REVISIÓN COMPREHENSIVA");
    console.log("=".repeat(50));
    console.log(`📊 Score Global: ${finalReport.summary.overallScore}/100`);
    console.log(`📋 Tablas Totales: ${finalReport.summary.totalTables}`);
    console.log(`🏷️  Naming Compliance: ${finalReport.summary.namingCompliance}`);
    console.log(`🗑️  Soft Delete: ${finalReport.summary.softDeleteCoverage}`);
    console.log(`📝 Auditoría: ${finalReport.summary.auditFieldsComplete}`);
    console.log(`🔒 RLS Security: ${finalReport.summary.rlsEnabled}`);
    console.log(`⚡ FK Indexes: ${finalReport.summary.missingFKIndexes} faltantes`);
    console.log(`🔧 Extensions: ${finalReport.summary.extensionsInstalled} instaladas`);

    if (finalReport.criticalIssues.length > 0) {
      console.log("\n🚨 CRITICAL ISSUES:");
      finalReport.criticalIssues.forEach(issue => console.log(`   ❌ ${issue}`));
    }

    if (finalReport.warnings.length > 0) {
      console.log("\n⚠️  WARNINGS:");
      finalReport.warnings.forEach(warning => console.log(`   ⚠️  ${warning}`));
    }

    if (finalReport.recommendations.length > 0) {
      console.log("\n💡 RECOMMENDATIONS:");
      finalReport.recommendations.forEach(rec => console.log(`   💡 ${rec}`));
    }

    // Guardar reporte en archivo
    await fs.writeFile(
      '03-poc/0301-database/REVISION-COMPREHENSIVA.json',
      JSON.stringify(finalReport, null, 2)
    );

    console.log("\n✅ Reporte guardado en: 03-poc/0301-database/REVISION-COMPREHENSIVA.json");

  } catch (error: any) {
    console.error("❌ Error en revisión:", error.message);
    process.exit(1);
  } finally {
    await client.end();
  }
}

comprehensiveDatabaseReview();
