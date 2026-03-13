-- CREAR PROGRESS UPDATES PARA PROYECTOS Y TAREAS

INSERT INTO progress.trn_progress_updates (
    id, project_id, task_id, user_id, progress_percentage, status, 
    notes, update_date, created_by, updated_by
) VALUES 
-- Progress updates para SourTrack (PRJ-MOJ-0006)
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Debugging código de Palmero' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    100.00, 'COMPLETED',
    'Debugging completado exitosamente. Todos los errores críticos han sido resueltos.',
    '2024-01-01'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Corrección de elementos del flujo inventario' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    100.00, 'COMPLETED',
    'Flujo de inventario corregido completamente. Optimización de procesos aplicada.',
    '2024-02-15'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Plantilla de presupuesto' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    100.00, 'COMPLETED',
    'Plantilla de presupuesto completada y validada.',
    '2024-02-01'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Manual de inventario' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    100.00, 'COMPLETED',
    'Manual de inventario completado. Documentación técnica finalizada.',
    '2024-02-17'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
-- Progress updates para Evalora.ai (PRJ-KLM-0022)
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0022' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Plantilla HUs' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    100.00, 'COMPLETED',
    'Plantillas de historias de usuario completadas y listas para uso.',
    '2024-03-01'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0022' LIMIT 1),
    NULL, -- Sin tarea específica
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    75.00, 'ON_TRACK',
    'Proyecto en buen camino. 75% de desarrollo completado.',
    '2024-03-15'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
-- Progress updates para Unitraffic (PRJ-UNT-0001)
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Acta Sesión 3' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    100.00, 'COMPLETED',
    'Acta de la tercera sesión documentada completamente.',
    '2023-01-15'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    (SELECT id FROM tasks.trn_tasks WHERE title = 'Desarrollo de API de gestión de tráfico' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    100.00, 'COMPLETED',
    'API de gestión de tráfico completada y funcional.',
    '2023-02-01'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
-- Progress update general para SourTrack
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    NULL, -- Sin tarea específica
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    85.00, 'ON_TRACK',
    'Proyecto SourTrack avanzando según lo planeado. 85% completado.',
    '2024-02-28'::date,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
);
