-- =============================================================================
-- EP-013: SEEDS PARA HISTORIAL DE PRESENCIA
-- =============================================================================
-- Propósito: Historial de cambios de presencia para testing
-- Tabla: presence.log_presence_history
-- =============================================================================

-- Insertar historial de cambios para los últimos 7 días
INSERT INTO presence.log_presence_history (
    user_id,
    from_state_id,
    to_state_id,
    changed_at,
    change_source,
    reason,
    metadata,
    task_context,
    project_context
)
SELECT
    u.id,
    ps1.id,
    ps2.id,
    now() - interval '7 days' + (random() * interval '7 days'),
    CASE
        WHEN random() < 0.7 THEN 'manual'
        WHEN random() < 0.9 THEN 'automatic'
        ELSE 'system'
    END,
    CASE
        WHEN ps2.code = 'vacaciones' THEN 'Vacaciones programadas'
        WHEN ps2.code = 'enfermo' THEN 'Indisposición temporal'
        WHEN ps2.code = 'en_reunion' THEN 'Reunión con cliente'
        WHEN ps2.code = 'en_pausa' THEN 'Descanso breve'
        WHEN ps2.code = 'fuera_oficina' THEN 'Trabajo remoto'
        ELSE 'Cambio de estado'
    END,
    jsonb_build_object(
        'ip_address', '192.168.1.' || (random() * 255)::int,
        'user_agent', 'Browser session',
        'session_id', 'session_' || u.id || '_' || (random() * 1000)::int,
        'location', CASE
            WHEN ps2.code = 'fuera_oficina' THEN 'Home office'
            ELSE 'Office'
        END
    ),
    CASE
        WHEN random() < 0.4 THEN jsonb_build_object(
            'task_id', (SELECT id FROM tasks.trn_tasks ORDER BY random() LIMIT 1),
            'task_name', 'Task ' || (random() * 1000)::int,
            'progress', (random() * 100)::int,
            'priority', CASE WHEN random() < 0.3 THEN 'high' WHEN random() < 0.6 THEN 'medium' ELSE 'low' END
        )
        ELSE '{}'::jsonb
    END,
    CASE
        WHEN random() < 0.5 THEN jsonb_build_object(
            'project_id', (SELECT id FROM projects.trn_projects ORDER BY random() LIMIT 1),
            'project_name', 'Project ' || (random() * 100)::int,
            'status', CASE WHEN random() < 0.4 THEN 'active' WHEN random() < 0.8 THEN 'planning' ELSE 'completed' END
        )
        ELSE '{}'::jsonb
    END
FROM base.mst_users u
CROSS JOIN presence.mst_presence_states ps1
CROSS JOIN presence.mst_presence_states ps2
WHERE ps1.id != ps2.id
  AND u.id IN (SELECT DISTINCT user_id FROM presence.trn_user_presence LIMIT 5)
ORDER BY random()
LIMIT 50;

-- Insertar algunos cambios recientes para testing
INSERT INTO presence.log_presence_history (
    user_id,
    from_state_id,
    to_state_id,
    changed_at,
    change_source,
    reason,
    metadata,
    task_context,
    project_context
)
SELECT
    u.id,
    ps1.id,
    ps2.id,
    now() - interval '2 hours' + (random() * interval '2 hours'),
    'manual',
    'Testing del sistema de presencia',
    jsonb_build_object(
        'test_session', true,
        'test_type', 'manual_change',
        'environment', 'development'
    ),
    CASE
        WHEN ps2.code = 'trabajando' THEN jsonb_build_object(
            'task_id', (SELECT id FROM tasks.trn_tasks ORDER BY random() LIMIT 1),
            'task_name', 'Development Task ' || (random() * 100)::int,
            'progress', 75,
            'priority', 'high'
        )
        WHEN ps2.code = 'en_reunion' THEN jsonb_build_object(
            'meeting_topic', 'Sprint Planning',
            'attendees', 5
        )
        ELSE '{}'::jsonb
    END,
    CASE
        WHEN ps2.code = 'trabajando' THEN jsonb_build_object(
            'project_id', (SELECT id FROM projects.trn_projects ORDER BY random() LIMIT 1),
            'project_name', 'Active Project',
            'status', 'active'
        )
        ELSE '{}'::jsonb
    END
FROM base.mst_users u
CROSS JOIN presence.mst_presence_states ps1
CROSS JOIN presence.mst_presence_states ps2
WHERE ps1.id != ps2.id
  AND ps1.code = 'conectado'
  AND ps2.code IN ('trabajando', 'en_reunion', 'en_pausa')
  AND u.id IN (SELECT DISTINCT user_id FROM presence.trn_user_presence LIMIT 3)
ORDER BY random()
LIMIT 10;

-- Verificar que se insertaron correctamente
SELECT
    'Usuario ' || lph.user_id as user_info,
    ps_from.name as from_state,
    ps_to.name as to_state,
    lph.changed_at,
    lph.change_source,
    lph.reason,
    lph.task_context,
    lph.project_context
FROM presence.log_presence_history lph
LEFT JOIN presence.mst_presence_states ps_from ON lph.from_state_id = ps_from.id
JOIN presence.mst_presence_states ps_to ON lph.to_state_id = ps_to.id
ORDER BY lph.changed_at DESC
LIMIT 20;
