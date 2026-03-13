-- =============================================================================
-- SEEDS: Etapas de Workflows del Sistema de Aprobación
-- =============================================================================
-- Propósito: Poblar etapas secuenciales para cada workflow maestro
-- Fuente: Definiciones de proceso para cada tipo de aprobación
-- =============================================================================

-- Etapas para "Cambio Estado Proyecto Crítico"
INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    1,
    'Aprobación Supervisor Técnico',
    'Validación técnica del cambio por supervisor del proyecto',
    'technical_supervisor',
    'single',
    24,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    2,
    'Aprobación CTO',
    'Validación técnica ejecutiva por Chief Technology Officer',
    'cto',
    'single',
    48,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para "Modificación Presupuesto Proyecto"
INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    1,
    'Aprobación Project Manager',
    'Validación inicial por Project Manager del impacto del cambio',
    'project_manager',
    'single',
    12,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Modificación Presupuesto Proyecto' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    2,
    'Aprobación CTO',
    'Validación técnica del cambio presupuestario',
    'cto',
    'single',
    24,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Modificación Presupuesto Proyecto' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    3,
    'Aprobación Ejecutiva',
    'Aprobación final por ejecutivo para cambios significativos',
    'executive',
    'quorum',
    72,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Modificación Presupuesto Proyecto' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para "Cambio Alcance Proyecto"
INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    1,
    'Aprobación Supervisor',
    'Validación del cambio de alcance por supervisor del proyecto',
    'project_supervisor',
    'single',
    24,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Cambio Alcance Proyecto' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    2,
    'Aprobación CTO',
    'Validación técnica del impacto del cambio de alcance',
    'cto',
    'single',
    48,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Cambio Alcance Proyecto' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para "Asignación Tarea Crítica"
INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    1,
    'Aprobación Supervisor Técnico',
    'Validación de skills del asignado para la tarea crítica',
    'technical_supervisor',
    'single',
    12,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    2,
    'Aprobación Project Manager',
    'Validación final por Project Manager de la asignación',
    'project_manager',
    'single',
    24,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para "Reasignación Tarea Crítica"
INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    1,
    'Aprobación Supervisor Técnico',
    'Validación de skills del nuevo asignado y justificación del cambio',
    'technical_supervisor',
    'single',
    8,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Reasignación Tarea Crítica' AND mw.entity_type = 'task'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para "Tarea Alta Prioridad"
INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    1,
    'Aprobación Líder Técnico',
    'Validación técnica de la prioridad y complejidad de la tarea',
    'technical_lead',
    'single',
    6,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Tarea Alta Prioridad' AND mw.entity_type = 'task'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para "Revisión Presupuestaria Mensual"
INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    1,
    'Aprobación Project Manager',
    'Revisión inicial por Project Manager del presupuesto mensual',
    'project_manager',
    'single',
    24,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Revisión Presupuestaria Mensual' AND mw.entity_type = 'budget'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    2,
    'Aprobación CTO',
    'Validación técnica del presupuesto mensual',
    'cto',
    'single',
    48,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Revisión Presupuestaria Mensual' AND mw.entity_type = 'budget'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para "Ajuste Presupuestario"
INSERT INTO approval.mst_workflow_stages (
    id, workflow_id, stage_order, name, description, required_role,
    approval_type, timeout_hours, can_reject, requires_comment_on_reject
) SELECT
    gen_random_uuid(),
    mw.id,
    1,
    'Aprobación Supervisor',
    'Validación del ajuste presupuestario por supervisor técnico',
    'technical_supervisor',
    'single',
    12,
    true,
    true
FROM approval.mst_workflows mw
WHERE mw.name = 'Ajuste Presupuestario' AND mw.entity_type = 'budget'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;
