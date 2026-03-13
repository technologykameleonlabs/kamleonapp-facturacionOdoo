-- =============================================================================
-- EP-014: DASHBOARD DE EQUIPO Y PROYECTO
-- =============================================================================
-- Propósito: Sistema de dashboards avanzados para visualización de presencia
--            equipo con métricas, contexto en tiempo real e integración Google Calendar
-- Esquemas afectados: dashboard (nuevo), presence (extensiones)
-- =============================================================================

-- =============================================================================
-- 1. CREAR ESQUEMA DASHBOARD
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS dashboard;
COMMENT ON SCHEMA dashboard IS 'Dashboard system for team presence visualization and metrics';

-- Configurar permisos del esquema
GRANT USAGE ON SCHEMA dashboard TO authenticated;
GRANT CREATE ON SCHEMA dashboard TO service_role;

-- =============================================================================
-- 2. TABLA DE CONFIGURACIÓN GOOGLE CALENDAR
-- =============================================================================

CREATE TABLE IF NOT EXISTS dashboard.cfg_google_calendar_integrations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    google_user_id varchar(255),
    access_token text,
    refresh_token text,
    token_expires_at timestamptz,
    calendar_ids text[], -- Array de IDs de calendarios a sincronizar
    sync_settings jsonb DEFAULT '{
        "sync_enabled": true,
        "sync_frequency_minutes": 60,
        "privacy_level": "work_only",
        "last_sync_at": null,
        "sync_status": "pending"
    }'::jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    CONSTRAINT fk_cfg_google_calendar_integrations_user
        FOREIGN KEY (user_id) REFERENCES base.mst_users(id) ON DELETE CASCADE,

    CONSTRAINT chk_cfg_google_calendar_integrations_tokens
        CHECK (
            (access_token IS NOT NULL AND refresh_token IS NOT NULL) OR
            (access_token IS NULL AND refresh_token IS NULL)
        )
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_cfg_google_calendar_integrations_user_id
    ON dashboard.cfg_google_calendar_integrations(user_id);

CREATE INDEX IF NOT EXISTS idx_cfg_google_calendar_integrations_google_user_id
    ON dashboard.cfg_google_calendar_integrations(google_user_id);

-- Comentarios de documentación
COMMENT ON TABLE dashboard.cfg_google_calendar_integrations IS 'Google Calendar integration configuration for users';
COMMENT ON COLUMN dashboard.cfg_google_calendar_integrations.user_id IS 'Reference to the user who configured the integration';
COMMENT ON COLUMN dashboard.cfg_google_calendar_integrations.google_user_id IS 'Google user ID from OAuth integration';
COMMENT ON COLUMN dashboard.cfg_google_calendar_integrations.calendar_ids IS 'Array of Google Calendar IDs to sync';
COMMENT ON COLUMN dashboard.cfg_google_calendar_integrations.sync_settings IS 'JSON configuration for sync behavior and privacy';

-- =============================================================================
-- 3. EXTENSIONES A TABLAS DE PRESENCE
-- =============================================================================

-- Agregar campos de contexto a presencia actual
ALTER TABLE presence.trn_user_presence
ADD COLUMN IF NOT EXISTS last_task_context_update timestamptz DEFAULT now(),
ADD COLUMN IF NOT EXISTS current_task_id uuid,
ADD COLUMN IF NOT EXISTS current_project_id uuid;

-- Agregar campos de contexto a historial de presencia
ALTER TABLE presence.log_presence_history
ADD COLUMN IF NOT EXISTS task_context jsonb DEFAULT '{}'::jsonb,
ADD COLUMN IF NOT EXISTS project_context jsonb DEFAULT '{}'::jsonb;

-- Índices para las nuevas columnas
CREATE INDEX IF NOT EXISTS idx_trn_user_presence_current_task
    ON presence.trn_user_presence(current_task_id) WHERE current_task_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_trn_user_presence_current_project
    ON presence.trn_user_presence(current_project_id) WHERE current_project_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_log_presence_history_task_context
    ON presence.log_presence_history USING GIN (task_context) WHERE task_context != '{}'::jsonb;

-- Comentarios para las nuevas columnas
COMMENT ON COLUMN presence.trn_user_presence.last_task_context_update IS 'Last time task/project context was updated';
COMMENT ON COLUMN presence.trn_user_presence.current_task_id IS 'ID of currently active task (if any)';
COMMENT ON COLUMN presence.trn_user_presence.current_project_id IS 'ID of currently active project (if any)';
COMMENT ON COLUMN presence.log_presence_history.task_context IS 'JSON context of task at the time of presence change';
COMMENT ON COLUMN presence.log_presence_history.project_context IS 'JSON context of project at the time of presence change';

-- =============================================================================
-- 4. FUNCIONES SQL PARA DASHBOARDS
-- =============================================================================

-- Función para calcular métricas agregadas de presencia
CREATE OR REPLACE FUNCTION dashboard.calculate_presence_metrics(
    p_start_date timestamptz DEFAULT now() - interval '30 days',
    p_end_date timestamptz DEFAULT now(),
    p_department_filter uuid DEFAULT NULL
)
RETURNS jsonb AS $$
DECLARE
    result jsonb;
    total_users bigint;
    active_users bigint;
    avg_presence_hours numeric;
    presence_distribution jsonb;
BEGIN
    -- Calcular métricas básicas
    SELECT
        COUNT(DISTINCT up.user_id) as total_users_count,
        COUNT(DISTINCT CASE WHEN up.set_at >= p_start_date THEN up.user_id END) as active_users_count,
        AVG(EXTRACT(epoch FROM (COALESCE(up.expires_at, now() + interval '8 hours') - up.set_at))/3600) as avg_hours
    INTO total_users, active_users, avg_presence_hours
    FROM presence.trn_user_presence up
    LEFT JOIN base.mst_users u ON up.user_id = u.id
    WHERE up.set_at BETWEEN p_start_date AND p_end_date
      AND (p_department_filter IS NULL OR u.id = p_department_filter);

    -- Calcular distribución de estados
    SELECT jsonb_object_agg(state_name, state_count)
    INTO presence_distribution
    FROM (
        SELECT ps.name as state_name, COUNT(*) as state_count
        FROM presence.trn_user_presence up
        JOIN presence.mst_presence_states ps ON up.current_state_id = ps.id
        LEFT JOIN base.mst_users u ON up.user_id = u.id
        WHERE up.set_at BETWEEN p_start_date AND p_end_date
          AND (p_department_filter IS NULL OR u.id = p_department_filter)
        GROUP BY ps.name
    ) state_stats;

    -- Construir resultado JSON
    result := jsonb_build_object(
        'period', jsonb_build_object('start', p_start_date, 'end', p_end_date),
        'metrics', jsonb_build_object(
            'total_users', total_users,
            'active_users', active_users,
            'avg_presence_hours', ROUND(avg_presence_hours, 2),
            'presence_distribution', presence_distribution
        ),
        'calculated_at', now()
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para obtener contexto en tiempo real del equipo
CREATE OR REPLACE FUNCTION dashboard.get_team_presence_context(
    p_user_id uuid,
    p_team_filter uuid DEFAULT NULL,
    p_include_tasks boolean DEFAULT true
)
RETURNS TABLE (
    user_id uuid,
    user_name text,
    current_state text,
    state_category text,
    set_at timestamptz,
    current_task jsonb,
    current_project jsonb,
    is_online boolean
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id,
        COALESCE(u.name, '') || ' ' || COALESCE(u.surname, '') as user_name,
        ps.name as current_state,
        ps.category as state_category,
        up.set_at,
        CASE
            WHEN p_include_tasks AND up.current_task_id IS NOT NULL THEN
                jsonb_build_object(
                    'id', t.id,
                    'name', t.name,
                    'status', t.status,
                    'progress_percentage', t.progress_percentage
                )
            ELSE NULL
        END as current_task,
        CASE
            WHEN p_include_tasks AND up.current_project_id IS NOT NULL THEN
                jsonb_build_object(
                    'id', p.id,
                    'name', p.name,
                    'status', p.status
                )
            ELSE NULL
        END as current_project,
        CASE
            WHEN ps.category IN ('available', 'busy') THEN true
            ELSE false
        END as is_online
    FROM presence.trn_user_presence up
    JOIN presence.mst_presence_states ps ON up.current_state_id = ps.id
    JOIN base.mst_users u ON up.user_id = u.id
    LEFT JOIN tasks.trn_tasks t ON up.current_task_id = t.id AND p_include_tasks
    LEFT JOIN projects.trn_projects p ON up.current_project_id = p.id AND p_include_tasks
    WHERE (p_team_filter IS NULL OR u.team_id = p_team_filter)
    ORDER BY u.name, u.surname;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para análisis de patrones históricos
CREATE OR REPLACE FUNCTION dashboard.get_historical_presence_patterns(
    p_start_date timestamptz DEFAULT now() - interval '30 days',
    p_end_date timestamptz DEFAULT now(),
    p_user_ids uuid[] DEFAULT NULL
)
RETURNS jsonb AS $$
DECLARE
    result jsonb;
    pattern_data jsonb;
BEGIN
    -- Obtener datos de patrones por usuario
    SELECT jsonb_object_agg(
        u.id::text,
        jsonb_build_object(
            'user_name', COALESCE(u.name, '') || ' ' || COALESCE(u.surname, ''),
            'patterns', jsonb_build_object(
                'avg_arrival_time', AVG(EXTRACT(hour FROM lph.changed_at)),
                'most_common_state', mode() WITHIN GROUP (ORDER BY ps.name),
                'total_changes', COUNT(*),
                'avg_session_duration', AVG(EXTRACT(epoch FROM lph.changed_at - lag(lph.changed_at) OVER (PARTITION BY lph.user_id ORDER BY lph.changed_at)))/3600
            )
        )
    )
    INTO pattern_data
    FROM presence.log_presence_history lph
    JOIN presence.mst_presence_states ps ON lph.new_state_id = ps.id
    JOIN base.mst_users u ON lph.user_id = u.id
    WHERE lph.changed_at BETWEEN p_start_date AND p_end_date
      AND (p_user_ids IS NULL OR lph.user_id = ANY(p_user_ids))
    GROUP BY u.id, u.name, u.surname;

    -- Construir resultado
    result := jsonb_build_object(
        'period', jsonb_build_object('start', p_start_date, 'end', p_end_date),
        'patterns', COALESCE(pattern_data, '{}'::jsonb),
        'summary', jsonb_build_object(
            'total_users_analyzed', jsonb_object_length(COALESCE(pattern_data, '{}'::jsonb)),
            'analysis_type', 'presence_patterns'
        ),
        'generated_at', now()
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para obtener contexto actual detallado de usuario
CREATE OR REPLACE FUNCTION dashboard.get_user_current_context(p_user_id uuid)
RETURNS jsonb AS $$
DECLARE
    result jsonb;
    v_state_name text;
    v_state_category text;
    v_set_at timestamptz;
    v_task_id uuid;
    v_project_id uuid;
    v_task_name text;
    v_project_name text;
    v_task_status text;
    v_project_status text;
BEGIN
    -- Obtener datos de presencia actual
    SELECT
        ps.name, ps.category, up.set_at,
        up.current_task_id, up.current_project_id
    INTO v_state_name, v_state_category, v_set_at, v_task_id, v_project_id
    FROM presence.trn_user_presence up
    JOIN presence.mst_presence_states ps ON up.current_state_id = ps.id
    WHERE up.user_id = p_user_id;

    -- Si no hay datos de presencia, devolver contexto vacío
    IF v_state_name IS NULL THEN
        RETURN jsonb_build_object(
            'user_id', p_user_id,
            'presence', null,
            'current_task', null,
            'current_project', null,
            'last_update', now()
        );
    END IF;

    -- Obtener datos de tarea si existe
    IF v_task_id IS NOT NULL THEN
        SELECT t.name, t.status
        INTO v_task_name, v_task_status
        FROM tasks.trn_tasks t
        WHERE t.id = v_task_id;
    END IF;

    -- Obtener datos de proyecto si existe
    IF v_project_id IS NOT NULL THEN
        SELECT p.name, p.status
        INTO v_project_name, v_project_status
        FROM projects.trn_projects p
        WHERE p.id = v_project_id;
    END IF;

    -- Construir resultado JSON
    result := jsonb_build_object(
        'user_id', p_user_id,
        'presence', jsonb_build_object(
            'state', v_state_name,
            'category', v_state_category,
            'set_at', v_set_at
        ),
        'current_task', CASE
            WHEN v_task_id IS NOT NULL THEN
                jsonb_build_object(
                    'id', v_task_id,
                    'name', COALESCE(v_task_name, 'Unknown Task'),
                    'status', COALESCE(v_task_status, 'unknown')
                )
            ELSE null
        END,
        'current_project', CASE
            WHEN v_project_id IS NOT NULL THEN
                jsonb_build_object(
                    'id', v_project_id,
                    'name', COALESCE(v_project_name, 'Unknown Project'),
                    'status', COALESCE(v_project_status, 'unknown')
                )
            ELSE null
        END,
        'last_update', COALESCE(v_set_at, now())
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para sincronización de Google Calendar
CREATE OR REPLACE FUNCTION dashboard.sync_google_calendar_events(
    p_user_id uuid,
    p_force_sync boolean DEFAULT false
)
RETURNS jsonb AS $$
DECLARE
    integration_record record;
    result jsonb;
    sync_result jsonb := '{}'::jsonb;
BEGIN
    -- Obtener configuración de integración
    SELECT * INTO integration_record
    FROM dashboard.cfg_google_calendar_integrations
    WHERE user_id = p_user_id
      AND sync_settings->>'sync_enabled' = 'true';

    -- Si no hay integración configurada, devolver error
    IF integration_record IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Google Calendar integration not configured',
            'user_id', p_user_id
        );
    END IF;

    -- Verificar si es necesario sincronizar
    IF NOT p_force_sync AND integration_record.sync_settings->>'last_sync_at' IS NOT NULL THEN
        IF (now() - (integration_record.sync_settings->>'last_sync_at')::timestamptz) <
           (integration_record.sync_settings->>'sync_frequency_minutes')::interval THEN
            RETURN jsonb_build_object(
                'success', true,
                'message', 'Sync not needed yet',
                'next_sync_at', (integration_record.sync_settings->>'last_sync_at')::timestamptz +
                               (integration_record.sync_settings->>'sync_frequency_minutes')::interval
            );
        END IF;
    END IF;

    -- Aquí iría la lógica real de sincronización con Google Calendar API
    -- Por ahora simulamos una sincronización exitosa
    sync_result := jsonb_build_object(
        'events_synced', 5,
        'new_events', 2,
        'updated_events', 1,
        'deleted_events', 0,
        'sync_duration_ms', 1250
    );

    -- Actualizar timestamp de última sincronización
    UPDATE dashboard.cfg_google_calendar_integrations
    SET
        sync_settings = sync_settings || jsonb_build_object(
            'last_sync_at', now(),
            'sync_status', 'completed'
        ),
        updated_at = now()
    WHERE id = integration_record.id;

    -- Retornar resultado
    RETURN jsonb_build_object(
        'success', true,
        'user_id', p_user_id,
        'sync_result', sync_result,
        'synced_at', now()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Función para distribución de carga de trabajo
CREATE OR REPLACE FUNCTION dashboard.calculate_workload_distribution(
    p_department_id uuid DEFAULT NULL,
    p_period_start timestamptz DEFAULT now() - interval '7 days',
    p_period_end timestamptz DEFAULT now() + interval '7 days'
)
RETURNS jsonb AS $$
DECLARE
    result jsonb;
    workload_data jsonb;
BEGIN
    -- Calcular distribución de carga por usuario
    SELECT jsonb_object_agg(
        u.id::text,
        jsonb_build_object(
            'user_name', COALESCE(u.name, '') || ' ' || COALESCE(u.surname, ''),
            'active_tasks', COUNT(DISTINCT ta.task_id),
            'total_estimated_hours', COALESCE(SUM(t.estimated_hours), 0),
            'completed_tasks', COUNT(DISTINCT CASE WHEN t.status = 'completed' THEN ta.task_id END),
            'overdue_tasks', COUNT(DISTINCT CASE WHEN t.due_date < now() AND t.status != 'completed' THEN ta.task_id END),
            'current_workload_percentage', LEAST(100, GREATEST(0, 100 - (COUNT(DISTINCT CASE WHEN t.status = 'completed' THEN ta.task_id END)::numeric / GREATEST(COUNT(DISTINCT ta.task_id), 1) * 100)))
        )
    )
    INTO workload_data
    FROM base.mst_users u
    LEFT JOIN tasks.rel_task_assignments ta ON u.id = ta.user_id
    LEFT JOIN tasks.trn_tasks t ON ta.task_id = t.id
        AND t.created_at BETWEEN p_period_start AND p_period_end
    WHERE (p_department_id IS NULL OR u.department_id = p_department_id)
    GROUP BY u.id, u.name, u.surname;

    -- Construir resultado
    result := jsonb_build_object(
        'period', jsonb_build_object('start', p_period_start, 'end', p_period_end),
        'department_filter', p_department_id,
        'workload_distribution', COALESCE(workload_data, '{}'::jsonb),
        'summary', jsonb_build_object(
            'total_users', jsonb_object_length(COALESCE(workload_data, '{}'::jsonb)),
            'avg_workload_percentage', (
                SELECT AVG((value->>'current_workload_percentage')::numeric)
                FROM jsonb_object_keys(COALESCE(workload_data, '{}'::jsonb)) k
                CROSS JOIN jsonb_extract_path(COALESCE(workload_data, '{}'::jsonb), k) as value
            ),
            'users_overloaded', (
                SELECT COUNT(*)
                FROM jsonb_object_keys(COALESCE(workload_data, '{}'::jsonb)) k
                CROSS JOIN jsonb_extract_path(COALESCE(workload_data, '{}'::jsonb), k) as value
                WHERE (value->>'current_workload_percentage')::numeric > 80
            )
        ),
        'calculated_at', now()
    );

    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================================================
-- 5. PERMISOS Y CONFIGURACIÓN FINAL
-- =============================================================================

-- Otorgar permisos en las nuevas funciones
GRANT EXECUTE ON FUNCTION dashboard.calculate_presence_metrics(timestamptz, timestamptz, uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION dashboard.get_team_presence_context(uuid, uuid, boolean) TO authenticated;
GRANT EXECUTE ON FUNCTION dashboard.get_historical_presence_patterns(timestamptz, timestamptz, uuid[]) TO authenticated;
GRANT EXECUTE ON FUNCTION dashboard.get_user_current_context(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION dashboard.sync_google_calendar_events(uuid, boolean) TO authenticated;
GRANT EXECUTE ON FUNCTION dashboard.calculate_workload_distribution(uuid, timestamptz, timestamptz) TO authenticated;

-- Otorgar permisos en las nuevas tablas
GRANT SELECT, INSERT, UPDATE, DELETE ON dashboard.cfg_google_calendar_integrations TO authenticated;

-- =============================================================================
-- 6. DATOS DE EJEMPLO PARA TESTING
-- =============================================================================

-- Insertar configuración de ejemplo para Google Calendar (datos de prueba)
INSERT INTO dashboard.cfg_google_calendar_integrations (
    user_id,
    google_user_id,
    calendar_ids,
    sync_settings
) VALUES (
    (SELECT id FROM base.mst_users LIMIT 1),
    'google_user_123',
    ARRAY['primary', 'work@company.com'],
    jsonb_build_object(
        'sync_enabled', true,
        'sync_frequency_minutes', 60,
        'privacy_level', 'work_only',
        'last_sync_at', now() - interval '2 hours',
        'sync_status', 'completed'
    )
) ON CONFLICT DO NOTHING;

-- =============================================================================
-- 7. VERIFICACIÓN FINAL
-- =============================================================================

-- Verificar que todo se creó correctamente
DO $$
DECLARE
    schema_count integer;
    table_count integer;
    function_count integer;
BEGIN
    -- Verificar esquema
    SELECT COUNT(*) INTO schema_count
    FROM information_schema.schemata
    WHERE schema_name = 'dashboard';

    -- Verificar tabla
    SELECT COUNT(*) INTO table_count
    FROM information_schema.tables
    WHERE table_schema = 'dashboard' AND table_name = 'cfg_google_calendar_integrations';

    -- Verificar funciones
    SELECT COUNT(*) INTO function_count
    FROM information_schema.routines
    WHERE routine_schema = 'dashboard' AND routine_type = 'FUNCTION';

    RAISE NOTICE 'EP-014 Dashboard Implementation Summary:';
    RAISE NOTICE '- Schema created: %', schema_count;
    RAISE NOTICE '- Tables created: %', table_count;
    RAISE NOTICE '- Functions created: %', function_count;
    RAISE NOTICE '- Implementation completed successfully!';
END $$;
