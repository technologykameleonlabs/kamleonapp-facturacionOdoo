-- TIME ENTRIES COMPLETOS BASADOS EN TAREAS EXISTENTES

-- Time entries para SourTrack
INSERT INTO time_tracking.trn_time_entries (
    id, user_id, project_id, task_id, entry_date, start_time, end_time, 
    hours_worked, description, is_billable, status, created_by, updated_by
) VALUES 
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Debugging código de Palmero' LIMIT 1),
    '2024-01-01'::date, '09:00'::time, '19:40'::time,
    10.67, 'Debugging y correccion de codigo', 
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
    8.00, 'Trabajo en correccion de flujo de inventario',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Plantilla de presupuesto' LIMIT 1),
    '2024-02-01'::date, '09:00'::time, '17:00'::time,
    8.00, 'Desarrollo de plantilla de presupuesto',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
);

-- Time entries para Evalora.ai
INSERT INTO time_tracking.trn_time_entries (
    id, user_id, project_id, task_id, entry_date, start_time, end_time, 
    hours_worked, description, is_billable, status, created_by, updated_by
) VALUES 
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0022' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Plantilla HUs' LIMIT 1),
    '2024-03-01'::date, '09:00'::time, '17:00'::time,
    8.00, 'Desarrollo de plantillas para historias de usuario',
    true, 'DRAFT',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
);

-- Time entries para Unitraffic
INSERT INTO time_tracking.trn_time_entries (
    id, user_id, project_id, task_id, entry_date, start_time, end_time, 
    hours_worked, description, is_billable, status, created_by, updated_by
) VALUES 
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Acta Sesión 3' LIMIT 1),
    '2023-01-15'::date, '09:00'::time, '13:00'::time,
    4.00, 'Redaccion y documentacion de acta de sesion',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Desarrollo de API de gestión de tráfico' LIMIT 1),
    '2023-02-01'::date, '09:00'::time, '17:00'::time,
    8.00, 'Implementacion de endpoints para gestion de trafico',
    true, 'APPROVED',
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
);

-- Verificación final
SELECT '=== TIME ENTRIES CREADOS ===' as section;
SELECT 
    COUNT(*) as total_time_entries,
    SUM(hours_worked) as total_hours,
    AVG(hours_worked) as avg_hours_per_entry
FROM time_tracking.trn_time_entries;

SELECT 'Time entries por proyecto:' as section;
SELECT 
    p.code as project_code,
    p.name as project_name,
    COUNT(te.id) as time_entries,
    SUM(te.hours_worked) as total_hours
FROM time_tracking.trn_time_entries te
JOIN projects.trn_projects p ON te.project_id = p.id
GROUP BY p.code, p.name
ORDER BY p.code;
