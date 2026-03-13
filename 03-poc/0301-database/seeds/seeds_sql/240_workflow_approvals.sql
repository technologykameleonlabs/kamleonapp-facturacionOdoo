-- =============================================================================
-- SEEDS: Historial de Aprobaciones de Workflows
-- =============================================================================
-- Propósito: Poblar historial de decisiones tomadas en workflows
-- Fuente: Simulación de aprobaciones históricas en el sistema
-- =============================================================================

-- Aprobaciones para workflows de proyectos
INSERT INTO approval.log_workflow_approvals (
    id, entity_workflow_id, stage_id, approver_id, decision,
    decision_at, comments, metadata
) SELECT
    gen_random_uuid(),
    ew.id,
    ws.id,
    (SELECT id FROM base.mst_users LIMIT 1),
    'approved',
    now() - interval '4 hours',
    'Cambio de estado aprobado. Se valida que cumple con los requisitos técnicos.',
    '{"approved_by_role": "technical_supervisor", "approval_time": "15 minutes", "justification": "Cumple con criterios de calidad"}'
FROM approval.trn_entity_workflows ew
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = ew.workflow_id
JOIN approval.mst_workflows mw ON mw.id = ew.workflow_id
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
    AND ew.status IN ('in_progress', 'approved')
    AND ws.stage_order = 1
LIMIT 2
ON CONFLICT DO NOTHING;

-- Aprobación CTO para proyecto
INSERT INTO approval.log_workflow_approvals (
    id, entity_workflow_id, stage_id, approver_id, decision,
    decision_at, comments, metadata
) SELECT
    gen_random_uuid(),
    ew.id,
    ws.id,
    (SELECT id FROM base.mst_users LIMIT 1 OFFSET 1),
    'approved',
    now() - interval '2 hours',
    'Como CTO, apruebo el cambio de estado. El supervisor técnico ya validó los aspectos técnicos.',
    '{"approved_by_role": "cto", "approval_time": "30 minutes", "risk_assessment": "low_risk"}'
FROM approval.trn_entity_workflows ew
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = ew.workflow_id
JOIN approval.mst_workflows mw ON mw.id = ew.workflow_id
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
    AND ew.status = 'approved'
    AND ws.stage_order = 2
LIMIT 1
ON CONFLICT DO NOTHING;

-- Aprobaciones para workflows de tareas críticas
INSERT INTO approval.log_workflow_approvals (
    id, entity_workflow_id, stage_id, approver_id, decision,
    decision_at, comments, metadata
) SELECT
    gen_random_uuid(),
    ew.id,
    ws.id,
    (SELECT id FROM base.mst_users LIMIT 1),
    'approved',
    now() - interval '1 hour',
    'El asignado tiene las skills necesarias para esta tarea crítica. Aprobado.',
    '{"approved_by_role": "technical_supervisor", "skills_validated": ["react", "typescript", "api_design"], "experience_years": 3}'
FROM approval.trn_entity_workflows ew
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = ew.workflow_id
JOIN approval.mst_workflows mw ON mw.id = ew.workflow_id
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
    AND ew.status IN ('in_progress', 'approved')
    AND ws.stage_order = 1
LIMIT 3
ON CONFLICT DO NOTHING;

-- Aprobación Project Manager para tarea crítica
INSERT INTO approval.log_workflow_approvals (
    id, entity_workflow_id, stage_id, approver_id, decision,
    decision_at, comments, metadata
) SELECT
    gen_random_uuid(),
    ew.id,
    ws.id,
    (SELECT id FROM base.mst_users LIMIT 1 OFFSET 2),
    'approved',
    now() - interval '30 minutes',
    'Asignación validada. El supervisor técnico ya confirmó las competencias.',
    '{"approved_by_role": "project_manager", "workload_impact": "acceptable", "deadline_compatibility": "good"}'
FROM approval.trn_entity_workflows ew
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = ew.workflow_id
JOIN approval.mst_workflows mw ON mw.id = ew.workflow_id
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
    AND ew.status = 'approved'
    AND ws.stage_order = 2
LIMIT 2
ON CONFLICT DO NOTHING;

-- Aprobaciones para presupuestos
INSERT INTO approval.log_workflow_approvals (
    id, entity_workflow_id, stage_id, approver_id, decision,
    decision_at, comments, metadata
) SELECT
    gen_random_uuid(),
    ew.id,
    ws.id,
    (SELECT id FROM base.mst_users LIMIT 1 OFFSET 1),
    'approved',
    now() - interval '3 days',
    'Presupuesto mensual revisado y aprobado. Los costos están dentro del rango esperado.',
    '{"approved_by_role": "cto", "budget_variance": "2.3%", "cost_categories": ["development", "infrastructure", "testing"]}'
FROM approval.trn_entity_workflows ew
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = ew.workflow_id
JOIN approval.mst_workflows mw ON mw.id = ew.workflow_id
WHERE mw.name = 'Revisión Presupuestaria Mensual' AND mw.entity_type = 'budget'
    AND ew.status = 'approved'
    AND ws.stage_order = 2
LIMIT 2
ON CONFLICT DO NOTHING;

-- Ejemplo de aprobación rechazada con comentario obligatorio
INSERT INTO approval.log_workflow_approvals (
    id, entity_workflow_id, stage_id, approver_id, decision,
    decision_at, comments, metadata
) SELECT
    gen_random_uuid(),
    ew.id,
    ws.id,
    (SELECT id FROM base.mst_users LIMIT 1),
    'rejected',
    now() - interval '1 day',
    'RECHAZADO: El asignado no tiene experiencia suficiente en integración de APIs complejas. Se requiere desarrollador senior con al menos 4 años de experiencia.',
    '{"rejected_by_role": "technical_supervisor", "rejection_reason": "insufficient_experience", "required_experience": "4+ years", "suggested_alternative": "developer_senior"}'
FROM approval.trn_entity_workflows ew
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = ew.workflow_id
JOIN approval.mst_workflows mw ON mw.id = ew.workflow_id
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
    AND ew.status = 'rejected'
    AND ws.stage_order = 1
LIMIT 1
ON CONFLICT DO NOTHING;

-- Aprobación delegada
INSERT INTO approval.log_workflow_approvals (
    id, entity_workflow_id, stage_id, approver_id, decision,
    decision_at, comments, metadata
) SELECT
    gen_random_uuid(),
    ew.id,
    ws.id,
    (SELECT id FROM base.mst_users LIMIT 1 OFFSET 3),
    'delegated',
    now() - interval '6 hours',
    'Delegado a CTO para revisión técnica especializada.',
    '{"delegated_by_role": "project_manager", "delegated_to_role": "cto", "delegation_reason": "technical_expertise_required"}'
FROM approval.trn_entity_workflows ew
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = ew.workflow_id
JOIN approval.mst_workflows mw ON mw.id = ew.workflow_id
WHERE mw.name = 'Modificación Presupuesto Proyecto' AND mw.entity_type = 'project'
    AND ew.status IN ('in_progress', 'approved')
    AND ws.stage_order = 2
LIMIT 1
ON CONFLICT DO NOTHING;

-- Escalación automática por timeout
INSERT INTO approval.log_workflow_approvals (
    id, entity_workflow_id, stage_id, approver_id, decision,
    decision_at, comments, metadata
) SELECT
    gen_random_uuid(),
    ew.id,
    ws.id,
    (SELECT id FROM base.mst_users LIMIT 1 OFFSET 2),
    'escalated',
    now() - interval '26 hours',
    'ESCALACIÓN AUTOMÁTICA: No se recibió respuesta en el tiempo esperado (24h). Escalado a siguiente nivel.',
    '{"escalation_reason": "timeout", "original_timeout": "24 hours", "escalated_to_role": "project_manager"}'
FROM approval.trn_entity_workflows ew
JOIN approval.mst_workflow_stages ws ON ws.workflow_id = ew.workflow_id
JOIN approval.mst_workflows mw ON mw.id = ew.workflow_id
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
    AND ew.status IN ('in_progress', 'approved')
    AND ws.stage_order = 1
LIMIT 1
ON CONFLICT DO NOTHING;
