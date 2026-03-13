-- =============================================================================
-- EP-013: SEEDS PARA ESTADOS DE USUARIO
-- =============================================================================
-- Propósito: Estados iniciales de presencia para usuarios de ejemplo
-- Tabla: presence.trn_user_presence
-- =============================================================================

-- Insertar estados iniciales para usuarios existentes
INSERT INTO presence.trn_user_presence (
    user_id,
    current_state_id,
    set_at,
    is_temporary,
    justification,
    last_task_context_update,
    current_task_id,
    current_project_id
)
SELECT
    u.id,
    ps.id,
    now() - interval '1 day' + (random() * interval '1 day'), -- Estado aleatorio en las últimas 24 horas
    false,
    CASE
        WHEN ps.code = 'vacaciones' THEN 'Vacaciones programadas'
        WHEN ps.code = 'enfermo' THEN 'Indisposición temporal'
        WHEN ps.code = 'fuera_oficina' THEN 'Trabajando desde casa'
        ELSE NULL
    END,
    now() - interval '30 minutes' + (random() * interval '1 hour'), -- Actualización de contexto reciente
    CASE
        WHEN random() < 0.6 THEN (SELECT id FROM tasks.trn_tasks ORDER BY random() LIMIT 1)
        ELSE NULL
    END,
    CASE
        WHEN random() < 0.7 THEN (SELECT id FROM projects.trn_projects ORDER BY random() LIMIT 1)
        ELSE NULL
    END
FROM base.mst_users u
CROSS JOIN presence.mst_presence_states ps
WHERE ps.code IN ('conectado', 'trabajando', 'fuera_oficina', 'vacaciones', 'enfermo')
  AND u.id NOT IN (SELECT user_id FROM presence.trn_user_presence)
ORDER BY u.id, random()
ON CONFLICT (user_id) DO NOTHING;

-- Actualizar algunos usuarios con estados temporales para testing
UPDATE presence.trn_user_presence
SET
    is_temporary = true,
    expires_at = now() + interval '30 minutes',
    justification = 'Reunión temporal'
WHERE user_id IN (
    SELECT user_id FROM presence.trn_user_presence
    WHERE current_state_id IN (
        SELECT id FROM presence.mst_presence_states WHERE code = 'en_reunion'
    )
    LIMIT 2
);

-- Verificar que se insertaron correctamente
SELECT
    'Usuario ' || u.id as user_info,
    ps.name as state_name,
    ps.code as state_code,
    pup.set_at,
    pup.is_temporary,
    pup.expires_at,
    pup.justification
FROM presence.trn_user_presence pup
JOIN base.mst_users u ON pup.user_id = u.id
JOIN presence.mst_presence_states ps ON pup.current_state_id = ps.id
ORDER BY pup.set_at DESC;
