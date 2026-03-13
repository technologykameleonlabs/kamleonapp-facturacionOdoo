-- SEEDS DE TAREAS BASADOS EN DATOS REALES DEL ARCHIVO FUENTE

INSERT INTO tasks.trn_tasks (
    id, project_id, type_id, stage_id, title, description, priority,
    estimated_hours, actual_hours, progress_percentage,
    planned_start_date, planned_end_date, actual_start_date, actual_end_date,
    created_at, updated_at, created_by, updated_by
) VALUES 
-- =========================================
-- TAREAS PARA SOURTRACK (PRJ-MOJ-0006)
-- =========================================
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.mst_task_types WHERE name = 'Backend Development' LIMIT 1),
    (SELECT id FROM tasks.mst_task_stages WHERE name = 'En Progreso'),
    'Debugging código de Palmero',
    'TI.W3.05-Debugging código de Palmero. Corrección de errores en el sistema',
    'HIGH',
    20.00, 10.67, 53.00,
    '2024-01-01'::date, '2024-02-15'::date, '2024-01-01'::date, NULL,
    now(), now(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.mst_task_types WHERE name = 'Database Design' LIMIT 1),
    (SELECT id FROM tasks.mst_task_stages WHERE name = 'En Progreso'),
    'Corrección de elementos del flujo inventario',
    'TI.W3.02-Corrección de elementos del flujo inventario',
    'HIGH',
    40.00, 235.08, 59.00,
    '2024-01-15'::date, '2024-03-01'::date, '2024-01-15'::date, NULL,
    now(), now(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.mst_task_types WHERE name = 'UI/UX Design' LIMIT 1),
    (SELECT id FROM tasks.mst_task_stages WHERE name = 'Completada'),
    'Plantilla de presupuesto',
    'Desarrollo de plantilla de presupuesto para el sistema',
    'HIGH',
    7.00, 8.00, 100.00,
    '2024-02-01'::date, '2024-02-10'::date, '2024-02-01'::date, '2024-02-08'::date,
    now(), now(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.mst_task_types WHERE name = 'Technical Documentation' LIMIT 1),
    (SELECT id FROM tasks.mst_task_stages WHERE name = 'Completada'),
    'Manual de inventario',
    'TI.W3.06-Realizar manual de inventario y documentación técnica',
    'HIGH',
    15.00, 15.50, 100.00,
    '2024-02-15'::date, '2024-03-01'::date, '2024-02-15'::date, '2024-02-28'::date,
    now(), now(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),

-- =========================================
-- TAREAS PARA EVALORA.AI (PRJ-KLM-0022)
-- =========================================
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0022' LIMIT 1),
    (SELECT id FROM tasks.mst_task_types WHERE name = 'Wireframing' LIMIT 1),
    (SELECT id FROM tasks.mst_task_stages WHERE name = 'Pendiente'),
    'Plantilla HUs',
    'Desarrollo de plantillas para historias de usuario',
    'HIGH',
    16.00, 0.00, 0.00,
    '2024-03-01'::date, '2024-03-15'::date, NULL, NULL,
    now(), now(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),

-- =========================================
-- TAREAS PARA UNITRAFFIC (PRJ-UNT-0001)
-- =========================================
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    (SELECT id FROM tasks.mst_task_types WHERE name = 'Project Coordination' LIMIT 1),
    (SELECT id FROM tasks.mst_task_stages WHERE name = 'Completada'),
    'Acta Sesión 3',
    'Redacción y documentación de acta de la sesión 3 del proyecto',
    'LOW',
    4.00, 0.00, 0.00,
    '2023-01-15'::date, '2023-01-20'::date, '2023-01-15'::date, '2023-01-18'::date,
    now(), now(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    (SELECT id FROM tasks.mst_task_types WHERE name = 'API Development' LIMIT 1),
    (SELECT id FROM tasks.mst_task_stages WHERE name = 'Completada'),
    'Desarrollo de API de gestión de tráfico',
    'Implementación de endpoints para gestión de tráfico y reportes',
    'HIGH',
    32.00, 28.50, 89.00,
    '2023-02-01'::date, '2023-03-15'::date, '2023-02-01'::date, '2023-03-10'::date,
    now(), now(),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
);

-- Verificación de tareas creadas
SELECT '=== TAREAS CREADAS ===' as section;
SELECT
    p.code as project_code,
    p.name as project_name,
    t.title,
    s.name as stage_name,
    t.priority,
    t.progress_percentage,
    t.actual_hours
FROM tasks.trn_tasks t
JOIN projects.trn_projects p ON t.project_id = p.id
LEFT JOIN tasks.mst_task_stages s ON t.stage_id = s.id
ORDER BY p.code, t.created_at;
