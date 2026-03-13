-- =============================================
-- LIMPIEZA: MOVER CONFIGURACIÓN DE DASHBOARD A MASTERDATA
-- =============================================

-- Crear la tabla en masterdata (si no existe)
CREATE TABLE IF NOT EXISTS masterdata.cfg_google_calendar_integrations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    google_calendar_id varchar(255) NOT NULL,
    integration_name varchar(100) NOT NULL,
    is_active boolean DEFAULT true,
    settings jsonb DEFAULT '{}',
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Copiar datos de dashboard a masterdata (si existe la tabla origen)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables
               WHERE table_schema = 'dashboard'
               AND table_name = 'cfg_google_calendar_integrations') THEN

        -- Copiar datos
        INSERT INTO masterdata.cfg_google_calendar_integrations
        SELECT * FROM dashboard.cfg_google_calendar_integrations
        ON CONFLICT DO NOTHING;

        RAISE NOTICE 'Datos copiados de dashboard a masterdata';
    ELSE
        RAISE NOTICE 'Tabla origen no existe en dashboard';
    END IF;
END $$;

-- Agregar comentario a la nueva tabla
COMMENT ON TABLE masterdata.cfg_google_calendar_integrations IS 'Configuraciones de integración con Google Calendar';

-- Verificar que la tabla se creó correctamente
SELECT 'TABLA CREADA EN MASTERDATA:' as status;
SELECT schemaname, tablename, tableowner
FROM pg_tables
WHERE schemaname = 'masterdata'
  AND tablename = 'cfg_google_calendar_integrations';

-- Verificar datos copiados
SELECT 'DATOS EN LA NUEVA TABLA:' as status;
SELECT COUNT(*) as registros_copiados
FROM masterdata.cfg_google_calendar_integrations;

-- Eliminar el esquema dashboard completo
DROP SCHEMA IF EXISTS dashboard CASCADE;

-- Verificar eliminación
SELECT 'ESQUEMA DASHBOARD ELIMINADO:' as status;
SELECT CASE
    WHEN NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'dashboard')
    THEN '✅ Esquema dashboard eliminado exitosamente'
    ELSE '❌ Error: esquema dashboard aún existe'
END as resultado;

-- Verificar que no existen esquemas users o timetracking
SELECT 'VERIFICACIÓN DE ESQUEMAS NO DESEADOS:' as status;
SELECT
    'users' as schema_name,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'users')
         THEN '❌ EXISTE - requiere eliminación'
         ELSE '✅ No existe'
    END as status
UNION ALL
SELECT
    'timetracking' as schema_name,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = 'timetracking')
         THEN '❌ EXISTE - requiere eliminación'
         ELSE '✅ No existe'
    END as status;

-- Listado final de esquemas relevantes para el proyecto
SELECT 'ESQUEMAS FINALES DEL PROYECTO:' as status;
SELECT schemaname, COUNT(*) as tables
FROM pg_tables
WHERE schemaname NOT LIKE 'pg_%'
  AND schemaname != 'information_schema'
  AND schemaname NOT IN ('progress', 'realtime', 'storage', 'vault')
GROUP BY schemaname
ORDER BY schemaname;

SELECT 'LIMPIEZA COMPLETADA - DASHBOARD MOVIDO A MASTERDATA' as final_status;
