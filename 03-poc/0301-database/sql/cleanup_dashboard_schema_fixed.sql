-- =============================================
-- LIMPIEZA: MOVER CONFIGURACIÓN DE DASHBOARD A MASTERDATA (VERSION CORREGIDA)
-- =============================================

-- Copiar datos de dashboard a masterdata usando SQL dinámico
DO $$
DECLARE
    copy_query text;
BEGIN
    -- Verificar si existe la tabla origen
    IF EXISTS (SELECT 1 FROM information_schema.tables
               WHERE table_schema = 'dashboard'
               AND table_name = 'cfg_google_calendar_integrations') THEN

        -- Crear tabla en masterdata copiando estructura
        EXECUTE 'CREATE TABLE IF NOT EXISTS masterdata.cfg_google_calendar_integrations AS
                 SELECT * FROM dashboard.cfg_google_calendar_integrations LIMIT 0';

        -- Copiar datos
        EXECUTE 'INSERT INTO masterdata.cfg_google_calendar_integrations
                 SELECT * FROM dashboard.cfg_google_calendar_integrations';

        RAISE NOTICE 'Datos copiados exitosamente de dashboard a masterdata';
    ELSE
        RAISE NOTICE 'Tabla origen no existe en dashboard';
    END IF;
END $$;

-- Agregar comentario a la nueva tabla
COMMENT ON TABLE masterdata.cfg_google_calendar_integrations IS 'Configuraciones de integración con Google Calendar';

-- Verificar que la tabla se creó correctamente en masterdata
SELECT 'TABLA EN MASTERDATA:' as status;
SELECT schemaname, tablename, tableowner
FROM pg_tables
WHERE schemaname = 'masterdata'
  AND tablename = 'cfg_google_calendar_integrations';

-- Verificar datos copiados
SELECT 'DATOS COPIADOS:' as status;
SELECT COUNT(*) as registros
FROM masterdata.cfg_google_calendar_integrations;

-- Ahora eliminar el esquema dashboard completo
DROP SCHEMA IF EXISTS dashboard CASCADE;

-- Verificar eliminación
SELECT 'VERIFICACIÓN ELIMINACIÓN:' as status;
SELECT CASE
    WHEN NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'dashboard')
    THEN '✅ Esquema dashboard eliminado exitosamente'
    ELSE '❌ Error: esquema dashboard aún existe'
END as resultado;

-- Verificar esquemas finales
SELECT 'ESQUEMAS FINALES DEL PROYECTO:' as status;
SELECT schemaname, COUNT(*) as tables
FROM pg_tables
WHERE schemaname NOT LIKE 'pg_%'
  AND schemaname != 'information_schema'
  AND schemaname NOT IN ('progress', 'realtime', 'storage', 'vault')
GROUP BY schemaname
ORDER BY schemaname;

SELECT 'LIMPIEZA COMPLETADA - DASHBOARD MOVIDO A MASTERDATA Y ELIMINADO' as final_status;
