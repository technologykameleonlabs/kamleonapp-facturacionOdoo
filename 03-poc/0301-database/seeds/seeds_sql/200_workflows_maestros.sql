-- =============================================================================
-- SEEDS: Workflows Maestros del Sistema de Aprobación
-- =============================================================================
-- Propósito: Poblar workflows maestros reutilizables para diferentes entidades
-- Fuente: Definiciones de negocio para flujos de aprobación
-- =============================================================================

-- Workflows para Proyectos
INSERT INTO approval.mst_workflows (
    id, name, description, icon, entity_type, is_active,
    created_by, updated_by
) VALUES
-- Workflow para cambios críticos de proyecto
(gen_random_uuid(), 'Cambio Estado Proyecto Crítico',
 'Workflow para cambios de estado críticos que requieren validación técnica y ejecutiva',
 'project-status-critical', 'project', true,
 (SELECT id FROM base.mst_users LIMIT 1),
 (SELECT id FROM base.mst_users LIMIT 1)),

-- Workflow para modificaciones de presupuesto
(gen_random_uuid(), 'Modificación Presupuesto Proyecto',
 'Workflow para cambios significativos en el presupuesto del proyecto',
 'project-budget-change', 'project', true,
 (SELECT id FROM base.mst_users LIMIT 1),
 (SELECT id FROM base.mst_users LIMIT 1)),

-- Workflow para cambios de alcance
(gen_random_uuid(), 'Cambio Alcance Proyecto',
 'Workflow para modificaciones importantes del alcance del proyecto',
 'project-scope-change', 'project', true,
 (SELECT id FROM base.mst_users LIMIT 1),
 (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name, entity_type) DO NOTHING;

-- Workflows para Tareas
INSERT INTO approval.mst_workflows (
    id, name, description, icon, entity_type, is_active,
    created_by, updated_by
) VALUES
-- Workflow para asignación de tareas críticas
(gen_random_uuid(), 'Asignación Tarea Crítica',
 'Workflow para asignación inicial de tareas críticas según skills requeridos',
 'task-critical-assignment', 'task', true,
 (SELECT id FROM base.mst_users LIMIT 1),
 (SELECT id FROM base.mst_users LIMIT 1)),

-- Workflow para reasignación de tareas críticas
(gen_random_uuid(), 'Reasignación Tarea Crítica',
 'Workflow para cambios de asignación en tareas críticas existentes',
 'task-critical-reassignment', 'task', true,
 (SELECT id FROM base.mst_users LIMIT 1),
 (SELECT id FROM base.mst_users LIMIT 1)),

-- Workflow para tareas de alta prioridad
(gen_random_uuid(), 'Tarea Alta Prioridad',
 'Workflow para tareas que requieren aprobación por impacto o complejidad',
 'task-high-priority', 'task', true,
 (SELECT id FROM base.mst_users LIMIT 1),
 (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name, entity_type) DO NOTHING;

-- Workflows adicionales para Presupuestos (ya tenemos el básico)
INSERT INTO approval.mst_workflows (
    id, name, description, icon, entity_type, is_active,
    created_by, updated_by
) VALUES
-- Workflow para revisiones presupuestarias mensuales
(gen_random_uuid(), 'Revisión Presupuestaria Mensual',
 'Workflow estándar para revisión mensual de presupuestos por PM y CTO',
 'budget-monthly-review', 'budget', true,
 (SELECT id FROM base.mst_users LIMIT 1),
 (SELECT id FROM base.mst_users LIMIT 1)),

-- Workflow para ajustes presupuestarios
(gen_random_uuid(), 'Ajuste Presupuestario',
 'Workflow para ajustes menores que requieren validación técnica',
 'budget-adjustment', 'budget', true,
 (SELECT id FROM base.mst_users LIMIT 1),
 (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name, entity_type) DO NOTHING;
