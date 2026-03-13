-- =============================================================================
-- SEEDS: Workflows Asignados a Entidades
-- =============================================================================
-- Propósito: Poblar ejemplos de workflows activos asignados a entidades existentes
-- Fuente: Simulación de workflows en ejecución en el sistema
-- =============================================================================

-- Workflows asignados a Proyectos existentes
INSERT INTO approval.trn_entity_workflows (
    id, entity_type, entity_id, workflow_id, status, current_stage_id,
    assigned_at, created_at, updated_at
) SELECT
    gen_random_uuid(),
    'project',
    p.id,
    mw.id,
    'pending',
    ws.id,
    now(),
    now(),
    now()
FROM projects.trn_projects p
CROSS JOIN approval.mst_workflows mw
LEFT JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id AND ws.stage_order = 1
WHERE mw.name = 'Cambio Estado Proyecto Crítico' AND mw.entity_type = 'project'
    AND p.workflow_id IS NULL
LIMIT 2
ON CONFLICT (entity_type, entity_id) DO NOTHING;

-- Workflows asignados a Tareas críticas existentes
INSERT INTO approval.trn_entity_workflows (
    id, entity_type, entity_id, workflow_id, status, current_stage_id,
    assigned_at, created_at, updated_at
) SELECT
    gen_random_uuid(),
    'task',
    t.id,
    mw.id,
    'in_progress',
    ws.id,
    now() - interval '2 hours',
    now() - interval '2 hours',
    now()
FROM tasks.trn_tasks t
CROSS JOIN approval.mst_workflows mw
LEFT JOIN approval.mst_workflow_stages ws ON ws.workflow_id = mw.id AND ws.stage_order = 1
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
    AND t.workflow_id IS NULL
LIMIT 3
ON CONFLICT (entity_type, entity_id) DO NOTHING;

-- Workflows asignados a Presupuestos existentes
INSERT INTO approval.trn_entity_workflows (
    id, entity_type, entity_id, workflow_id, status, current_stage_id,
    assigned_at, created_at, updated_at
) SELECT
    gen_random_uuid(),
    'budget',
    b.id,
    mw.id,
    'approved',
    NULL,
    now() - interval '1 week',
    now() - interval '1 week',
    now() - interval '1 day'
FROM budgeting.trn_monthly_budgets b
CROSS JOIN approval.mst_workflows mw
WHERE mw.name = 'Revisión Presupuestaria Mensual' AND mw.entity_type = 'budget'
    AND b.workflow_id IS NULL
LIMIT 2
ON CONFLICT (entity_type, entity_id) DO NOTHING;

-- Workflow completado exitosamente
INSERT INTO approval.trn_entity_workflows (
    id, entity_type, entity_id, workflow_id, status, current_stage_id,
    assigned_at, completed_at, created_at, updated_at
) SELECT
    gen_random_uuid(),
    'project',
    p.id,
    mw.id,
    'approved',
    NULL,
    now() - interval '5 days',
    now() - interval '2 days',
    now() - interval '5 days',
    now() - interval '2 days'
FROM projects.trn_projects p
CROSS JOIN approval.mst_workflows mw
WHERE mw.name = 'Modificación Presupuesto Proyecto' AND mw.entity_type = 'project'
    AND p.workflow_id IS NULL
LIMIT 1
ON CONFLICT (entity_type, entity_id) DO NOTHING;

-- Workflow rechazado
INSERT INTO approval.trn_entity_workflows (
    id, entity_type, entity_id, workflow_id, status, current_stage_id,
    assigned_at, completed_at, created_at, updated_at
) SELECT
    gen_random_uuid(),
    'task',
    t.id,
    mw.id,
    'rejected',
    NULL,
    now() - interval '3 days',
    now() - interval '1 day',
    now() - interval '3 days',
    now() - interval '1 day'
FROM tasks.trn_tasks t
CROSS JOIN approval.mst_workflows mw
WHERE mw.name = 'Reasignación Tarea Crítica' AND mw.entity_type = 'task'
    AND t.workflow_id IS NULL
LIMIT 1
ON CONFLICT (entity_type, entity_id) DO NOTHING;
