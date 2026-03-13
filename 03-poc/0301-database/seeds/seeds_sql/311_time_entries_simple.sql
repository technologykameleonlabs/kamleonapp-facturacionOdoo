-- Versión simplificada del seed con menos registros
INSERT INTO time_tracking.trn_time_entries (
    id, user_id, project_id, task_id, entry_date, start_time, end_time, 
    hours_worked, description, is_billable, status, created_by, updated_by
) VALUES 
-- Solo 3 entradas para probar
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
    NULL, -- Sin task específica
    '2024-01-20'::date, '09:00'::time, '17:00'::time,
    8.00, 'Trabajo general en proyecto',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
);
