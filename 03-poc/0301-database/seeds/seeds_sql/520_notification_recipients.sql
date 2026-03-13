-- =============================================================================
-- EP-025: SEEDS PARA CONFIGURACIÓN DE DESTINATARIOS
-- =============================================================================
-- Propósito: Configuración de destinatarios para notificaciones
-- Tabla: notifications.cfg_notification_recipients
-- =============================================================================

-- Destinatarios para cambios de presencia - Miembros del equipo
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Miembros del equipo',
    'custom',
    jsonb_build_object(
        'query_type', 'team_members',
        'exclude_sender', true,
        'max_recipients', 10
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_change'
ON CONFLICT DO NOTHING;

-- Destinatarios para estados críticos - Manager del usuario
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Manager directo',
    'custom',
    jsonb_build_object(
        'query_type', 'user_manager',
        'fallback', 'team_lead'
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_critical'
ON CONFLICT DO NOTHING;

-- Destinatarios para estados críticos - Miembros del equipo
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Miembros del equipo',
    'custom',
    jsonb_build_object(
        'query_type', 'team_members',
        'exclude_sender', false,
        'max_recipients', 5
    ),
    2
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_critical'
ON CONFLICT DO NOTHING;

-- Destinatarios para tareas asignadas - Usuario asignado
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Usuario asignado',
    'custom',
    jsonb_build_object(
        'query_type', 'task_assignee',
        'context_field', 'assignee_id'
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'task_assigned'
ON CONFLICT DO NOTHING;

-- Destinatarios para tareas próximas a vencer - Usuario asignado
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Usuario asignado',
    'custom',
    jsonb_build_object(
        'query_type', 'task_assignee',
        'context_field', 'assignee_id'
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'task_due_soon'
ON CONFLICT DO NOTHING;

-- Destinatarios para tareas vencidas - Usuario asignado y project manager
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Usuario asignado',
    'custom',
    jsonb_build_object(
        'query_type', 'task_assignee',
        'context_field', 'assignee_id'
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'task_overdue'
ON CONFLICT DO NOTHING;

INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Project Manager',
    'custom',
    jsonb_build_object(
        'query_type', 'project_manager',
        'context_field', 'project_id'
    ),
    2
FROM notifications.mst_notification_types nt
WHERE nt.code = 'task_overdue'
ON CONFLICT DO NOTHING;

-- Destinatarios para fechas límite de proyecto - Miembros del proyecto
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Miembros del proyecto',
    'custom',
    jsonb_build_object(
        'query_type', 'project_members',
        'context_field', 'project_id',
        'max_recipients', 15
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'project_deadline'
ON CONFLICT DO NOTHING;

-- Destinatarios para aprobaciones requeridas - Usuario con rol específico
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Aprobador designado',
    'custom',
    jsonb_build_object(
        'query_type', 'role_users',
        'role_code', 'approver',
        'context_field', 'required_role'
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'approval_needed'
ON CONFLICT DO NOTHING;

-- Destinatarios para recordatorios de tiempo - Usuario específico
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Usuario objetivo',
    'custom',
    jsonb_build_object(
        'query_type', 'specific_user',
        'context_field', 'target_user_id'
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'time_entry_reminder'
ON CONFLICT DO NOTHING;

-- Destinatarios para alertas de presupuesto - Managers y CTO
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Project Managers',
    'custom',
    jsonb_build_object(
        'query_type', 'role_users',
        'role_code', 'project_manager'
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code = 'budget_alert'
ON CONFLICT DO NOTHING;

INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'CTO',
    'custom',
    jsonb_build_object(
        'query_type', 'role_users',
        'role_code', 'cto'
    ),
    2
FROM notifications.mst_notification_types nt
WHERE nt.code = 'budget_alert'
ON CONFLICT DO NOTHING;

-- Destinatarios para notificaciones del sistema - Todos los usuarios activos
INSERT INTO notifications.cfg_notification_recipients (
    notification_type_id,
    name,
    recipient_type,
    recipient_config,
    priority
)
SELECT
    nt.id,
    'Todos los usuarios activos',
    'custom',
    jsonb_build_object(
        'query_type', 'active_users',
        'max_recipients', 100
    ),
    1
FROM notifications.mst_notification_types nt
WHERE nt.code IN ('system_maintenance', 'welcome_new_user')
ON CONFLICT DO NOTHING;

-- Verificar que se insertaron correctamente
SELECT
    nt.name as notification_type,
    r.name as recipient_name,
    r.recipient_type,
    r.priority
FROM notifications.cfg_notification_recipients r
JOIN notifications.mst_notification_types nt ON r.notification_type_id = nt.id
ORDER BY nt.module, nt.name, r.priority;
