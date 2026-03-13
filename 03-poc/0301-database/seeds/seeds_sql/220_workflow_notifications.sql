-- =============================================================================
-- SEEDS: Configuración de Notificaciones de Workflows
-- =============================================================================
-- Propósito: Poblar configuraciones de notificaciones para cada workflow y etapa
-- Fuente: Definiciones de comunicación para flujos de aprobación
-- =============================================================================

-- Notificaciones para "Cambio Estado Proyecto Crítico"
INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    ws.id,
    'assignment',
    ws.required_role,
    'Cambio Estado Proyecto Crítico - Aprobación Requerida',
    'Se requiere su aprobación para un cambio crítico de estado en el proyecto {{project_name}}. Razón: {{change_reason}}. Por favor revise y tome una decisión antes de {{deadline}}.',
    '["email", "in_app"]',
    'immediate',
    0
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
    AND ws.stage_order = 1
ON CONFLICT DO NOTHING;

INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    ws.id,
    'reminder',
    ws.required_role,
    'Recordatorio: Cambio Estado Proyecto Crítico Pendiente',
    'Le recordamos que tiene pendiente la aprobación de un cambio crítico de estado en el proyecto {{project_name}}. Tiene {{hours_left}} horas para completar esta aprobación.',
    '["email"]',
    'delayed',
    12
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
    AND ws.stage_order = 1
ON CONFLICT DO NOTHING;

INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    ws.id,
    'escalation',
    'project_manager',
    'Escalación: Cambio Estado Proyecto Crítico Sin Respuesta',
    'El cambio crítico de estado en el proyecto {{project_name}} no ha recibido respuesta en el tiempo esperado. Se ha escalado para su atención inmediata.',
    '["email", "in_app", "slack"]',
    'delayed',
    25
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
    AND ws.stage_order = 1
ON CONFLICT DO NOTHING;

-- Notificaciones para segunda etapa del workflow de proyecto crítico
INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    ws.id,
    'assignment',
    ws.required_role,
    'Cambio Estado Proyecto Crítico - Aprobación CTO Requerida',
    'Como CTO, se requiere su aprobación técnica para un cambio crítico de estado en el proyecto {{project_name}}. El supervisor técnico ya ha aprobado este cambio.',
    '["email", "in_app"]',
    'immediate',
    0
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
    AND ws.stage_order = 2
ON CONFLICT DO NOTHING;

-- Notificaciones para "Asignación Tarea Crítica"
INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    ws.id,
    'assignment',
    ws.required_role,
    'Nueva Tarea Crítica Asignada - Aprobación Requerida',
    'Se ha solicitado asignar la tarea crítica "{{task_title}}" a {{assignee_name}}. Por favor valide que el asignado tiene las skills necesarias para esta tarea.',
    '["email", "in_app"]',
    'immediate',
    0
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
    AND ws.stage_order = 1
ON CONFLICT DO NOTHING;

INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    ws.id,
    'assignment',
    ws.required_role,
    'Tarea Crítica - Aprobación Final Requerida',
    'La asignación de la tarea crítica "{{task_title}}" ha sido aprobada técnicamente. Como Project Manager, por favor dé su aprobación final.',
    '["email", "in_app"]',
    'immediate',
    0
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
    AND ws.stage_order = 2
ON CONFLICT DO NOTHING;

-- Notificaciones para "Revisión Presupuestaria Mensual"
INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    ws.id,
    'assignment',
    ws.required_role,
    'Revisión Presupuestaria Mensual - Aprobación Requerida',
    'El presupuesto mensual de {{month_year}} para el proyecto {{project_name}} requiere su revisión. Monto total: ${{budget_amount}}.',
    '["email", "in_app"]',
    'immediate',
    0
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id
WHERE mw.name = 'Revisión Presupuestaria Mensual' AND mw.entity_type = 'budget'
    AND ws.stage_order = 1
ON CONFLICT DO NOTHING;

INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    ws.id,
    'assignment',
    ws.required_role,
    'Revisión Presupuestaria Mensual - Aprobación CTO Requerida',
    'Como CTO, se requiere su validación técnica del presupuesto mensual de {{month_year}} para el proyecto {{project_name}}.',
    '["email", "in_app"]',
    'immediate',
    0
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id
WHERE mw.name = 'Revisión Presupuestaria Mensual' AND mw.entity_type = 'budget'
    AND ws.stage_order = 2
ON CONFLICT DO NOTHING;

-- Notificaciones de completado para todos los workflows
INSERT INTO approval.cfg_workflow_notifications (
    id, workflow_id, stage_id, notification_type, recipient_role,
    template_subject, template_body, channels, timing, delay_hours
) SELECT
    gen_random_uuid(),
    mw.id,
    NULL,
    'completion',
    NULL,
    'Workflow Completado Exitosamente',
    'El workflow "{{workflow_name}}" para {{entity_type}} "{{entity_name}}" ha sido completado exitosamente.',
    '["email", "in_app"]',
    'immediate',
    0
FROM approval.mst_workflows mw
WHERE mw.is_active = true
ON CONFLICT DO NOTHING;
