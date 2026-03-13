-- =============================================
-- EP-020: LIMPIEZA DE TABLAS ANTIGUAS
-- Eliminar tablas con nombres antiguos
-- =============================================

-- Eliminar tablas antiguas (sin prefijo analytics_)
DROP TABLE IF EXISTS analytics.mst_categories CASCADE;
DROP TABLE IF EXISTS analytics.mst_entry_stages CASCADE;
DROP TABLE IF EXISTS analytics.mst_entry_types CASCADE;

-- Verificar que solo quedan las tablas correctas
SELECT 'TABLAS RESTANTES EN ANALYTICS:' as status;
SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname = 'analytics'
ORDER BY tablename;

-- Verificar que las nuevas tablas siguen existiendo
SELECT 'VERIFICACIÓN DE TABLAS NUEVAS:' as status;
SELECT
    'mst_analytics_entry_types' as table_name,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables
                     WHERE table_schema = 'analytics'
                     AND table_name = 'mst_analytics_entry_types')
         THEN 'EXISTS' ELSE 'MISSING' END as status
UNION ALL
SELECT
    'mst_analytics_categories' as table_name,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables
                     WHERE table_schema = 'analytics'
                     AND table_name = 'mst_analytics_categories')
         THEN 'EXISTS' ELSE 'MISSING' END as status
UNION ALL
SELECT
    'mst_analytics_stages' as table_name,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables
                     WHERE table_schema = 'analytics'
                     AND table_name = 'mst_analytics_stages')
         THEN 'EXISTS' ELSE 'MISSING' END as status
UNION ALL
SELECT
    'trn_analytic_entries' as table_name,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables
                     WHERE table_schema = 'analytics'
                     AND table_name = 'trn_analytic_entries')
         THEN 'EXISTS' ELSE 'MISSING' END as status;

-- Verificar datos en las tablas nuevas
SELECT 'DATOS EN TABLAS NUEVAS:' as status;
SELECT 'Entry Types:' as table_name, COUNT(*) as records FROM analytics.mst_analytics_entry_types
UNION ALL
SELECT 'Categories:' as table_name, COUNT(*) as records FROM analytics.mst_analytics_categories
UNION ALL
SELECT 'Stages:' as table_name, COUNT(*) as records FROM analytics.mst_analytics_stages
UNION ALL
SELECT 'Analytic Entries:' as table_name, COUNT(*) as records FROM analytics.trn_analytic_entries;

SELECT 'LIMPIEZA COMPLETADA - TABLAS ANTIGUAS ELIMINADAS' as final_status;
