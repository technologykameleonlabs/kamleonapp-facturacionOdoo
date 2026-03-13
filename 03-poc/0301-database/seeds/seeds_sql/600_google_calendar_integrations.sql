-- =============================================================================
-- EP-014: SEEDS PARA CONFIGURACIÓN GOOGLE CALENDAR
-- =============================================================================
-- Propósito: Configuraciones de integración con Google Calendar para usuarios
-- Tabla: dashboard.cfg_google_calendar_integrations
-- =============================================================================

-- Insertar configuraciones de ejemplo para algunos usuarios
INSERT INTO dashboard.cfg_google_calendar_integrations (
    user_id,
    google_user_id,
    access_token,
    refresh_token,
    token_expires_at,
    calendar_ids,
    sync_settings
) VALUES
(
    (SELECT id FROM base.mst_users LIMIT 1),
    'google_user_12345@example.com',
    'ya29.sample_access_token_for_testing_purposes_only',
    '1//sample_refresh_token_for_testing_only',
    now() + interval '1 hour',
    ARRAY['primary', 'work@company.com', 'personal@example.com'],
    jsonb_build_object(
        'sync_enabled', true,
        'sync_frequency_minutes', 60,
        'privacy_level', 'work_only',
        'last_sync_at', now() - interval '30 minutes',
        'sync_status', 'completed',
        'auto_create_events', false,
        'event_types_to_sync', ARRAY['work', 'meetings'],
        'timezone', 'America/Bogota'
    )
),
(
    (SELECT id FROM base.mst_users OFFSET 1 LIMIT 1),
    'google_user_67890@example.com',
    'ya29.another_sample_access_token_for_testing',
    '1//another_sample_refresh_token_for_testing',
    now() + interval '2 hours',
    ARRAY['primary'],
    jsonb_build_object(
        'sync_enabled', true,
        'sync_frequency_minutes', 30,
        'privacy_level', 'all_events',
        'last_sync_at', now() - interval '15 minutes',
        'sync_status', 'completed',
        'auto_create_events', true,
        'event_types_to_sync', ARRAY['work', 'personal', 'meetings'],
        'timezone', 'America/New_York'
    )
),
(
    (SELECT id FROM base.mst_users OFFSET 2 LIMIT 1),
    'google_user_99999@example.com',
    'ya29.third_sample_access_token_for_testing',
    '1//third_sample_refresh_token_for_testing',
    now() + interval '45 minutes',
    ARRAY['work@company.com', 'team@company.com'],
    jsonb_build_object(
        'sync_enabled', false,
        'sync_frequency_minutes', 120,
        'privacy_level', 'work_only',
        'last_sync_at', null,
        'sync_status', 'pending',
        'auto_create_events', false,
        'event_types_to_sync', ARRAY['work', 'meetings'],
        'timezone', 'Europe/Madrid'
    )
)
ON CONFLICT DO NOTHING;

-- Insertar configuración para usuario sin tokens (solo configuración básica)
INSERT INTO dashboard.cfg_google_calendar_integrations (
    user_id,
    google_user_id,
    calendar_ids,
    sync_settings
) VALUES
(
    (SELECT id FROM base.mst_users OFFSET 3 LIMIT 1),
    null,
    ARRAY['primary'],
    jsonb_build_object(
        'sync_enabled', false,
        'sync_frequency_minutes', 60,
        'privacy_level', 'work_only',
        'last_sync_at', null,
        'sync_status', 'not_configured',
        'auto_create_events', false,
        'event_types_to_sync', ARRAY['work'],
        'timezone', 'UTC'
    )
)
ON CONFLICT DO NOTHING;

-- Verificar que se insertaron correctamente
SELECT
    'Usuario ' || gci.user_id as user_info,
    gci.google_user_id,
    gci.calendar_ids,
    gci.sync_settings->>'sync_enabled' as sync_enabled,
    gci.sync_settings->>'privacy_level' as privacy_level,
    gci.sync_settings->>'sync_status' as sync_status,
    gci.created_at
FROM dashboard.cfg_google_calendar_integrations gci
ORDER BY gci.created_at DESC;

-- Mostrar resumen de configuraciones
SELECT
    COUNT(*) as total_configurations,
    COUNT(*) FILTER (WHERE sync_settings->>'sync_enabled' = 'true') as enabled_configs,
    COUNT(*) FILTER (WHERE access_token IS NOT NULL) as with_tokens,
    array_agg(DISTINCT sync_settings->>'privacy_level') as privacy_levels
FROM dashboard.cfg_google_calendar_integrations;
