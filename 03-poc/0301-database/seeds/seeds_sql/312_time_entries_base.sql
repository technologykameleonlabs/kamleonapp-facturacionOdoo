-- CREAR TIME ENTRIES BASADOS EN DATOS REALES DE LAS TAREAS

INSERT INTO time_tracking.trn_time_entries (
    id, user_id, project_id, task_id, entry_date, start_time, end_time, 
    hours_worked, description, is_billable, status, created_by, updated_by
) VALUES 
-- Time entries para "Debugging código de Palmero" (10.67 horas)
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Debugging código de Palmero' LIMIT 1),
    '2024-01-01'::date, '09:00'::time, '19:40'::time,
    10.67, 'Debugging y corrección de código en el sistema Palmero', 
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
-- Time entries para "Corrección de elementos del flujo inventario" (235.08 horas - dividido en múltiples entradas)
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Corrección de elementos del flujo inventario' LIMIT 1),
    '2024-01-15'::date, '09:00'::time, '18:00'::time,
    8.00, 'Trabajo en corrección de flujo de inventario - día 1',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Corrección de elementos del flujo inventario' LIMIT 1),
    '2024-01-16'::date, '09:00'::time, '18:00'::time,
    8.00, 'Trabajo en corrección de flujo de inventario - día 2',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Corrección de elementos del flujo inventario' LIMIT 1),
    '2024-01-17'::date, '09:00'::time, '18:00'::time,
    8.00, 'Trabajo en corrección de flujo de inventario - día 3',
    true, 'PENDING',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
-- Time entries para "Plantilla de presupuesto" (8.00 horas)
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Plantilla de presupuesto' LIMIT 1),
    '2024-02-01'::date, '09:00'::time, '17:00'::time,
    8.00, 'Desarrollo de plantilla de presupuesto para el sistema',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
-- Time entries para "Manual de inventario" (15.50 horas)
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Manual de inventario' LIMIT 1),
    '2024-02-15'::date, '09:00'::time, '18:00'::time,
    7.50, 'Documentación del manual de inventario - parte 1',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Manual de inventario' LIMIT 1),
    '2024-02-16'::date, '09:00'::time, '16:00'::time,
    6.00, 'Documentación del manual de inventario - parte 2',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Manual de inventario' LIMIT 1),
    '2024-02-17'::date, '09:00'::time, '13:00'::time,
    4.00, 'Finalización del manual de inventario',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
);

-- Verificación de time entries creados
SELECT '=== TIME ENTRIES CREADOS ===' as section;
SELECT 
    te.entry_date,
    p.code as project_code,
    p.name as project_name,
    t.title as task_title,
    te.hours_worked,
    te.status,
    te.is_billable
FROM time_tracking.trn_time_entries te
JOIN projects.trn_projects p ON te.project_id = p.id
LEFT JOIN tasks.trn_tasks t ON te.task_id = t.id
ORDER BY te.entry_date, te.created_at;
