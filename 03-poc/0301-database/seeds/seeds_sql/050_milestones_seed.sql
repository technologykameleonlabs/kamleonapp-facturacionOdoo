-- CREAR MILESTONES PARA PROYECTOS EXISTENTES

INSERT INTO progress.trn_milestones (
    id, project_id, name, description, planned_date, actual_date, 
    status, is_critical, created_by, updated_by
) VALUES 
-- Milestones para SourTrack (PRJ-MOJ-0006)
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    'Inicio de proyecto',
    'Configuración inicial del proyecto, setup de entorno y definición de alcance',
    '2023-12-01'::date, '2023-12-01'::date,
    'COMPLETED', true,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    'Desarrollo del sistema Palmero',
    'Implementación completa del sistema de inventario Palmero',
    '2024-01-15'::date, '2024-01-10'::date,
    'COMPLETED', true,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    'Corrección de flujo inventario',
    'Corrección y optimización del flujo de inventario',
    '2024-01-30'::date, '2024-02-15'::date,
    'COMPLETED', false,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
    'Documentación completa',
    'Manual de inventario y documentación del sistema',
    '2024-03-01'::date, NULL,
    'PENDING', false,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
-- Milestones para Evalora.ai (PRJ-KLM-0022)
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0022' LIMIT 1),
    'Análisis de requisitos',
    'Definición de historias de usuario y requisitos del sistema de evaluación',
    '2024-02-15'::date, '2024-02-20'::date,
    'COMPLETED', true,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0022' LIMIT 1),
    'Desarrollo de plantillas HU',
    'Creación de plantillas para historias de usuario',
    '2024-03-15'::date, '2024-03-10'::date,
    'COMPLETED', false,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0022' LIMIT 1),
    'Implementación del sistema',
    'Desarrollo completo del sistema Evalora.ai',
    '2024-04-30'::date, NULL,
    'PENDING', true,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
-- Milestones para Unitraffic (PRJ-UNT-0001)
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    'Sesión inicial',
    'Primera reunión y definición de alcance del proyecto',
    '2022-12-15'::date, '2023-01-15'::date,
    'COMPLETED', true,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    'Desarrollo de API',
    'Implementación de la API de gestión de tráfico',
    '2023-02-15'::date, '2023-02-01'::date,
    'COMPLETED', true,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
),
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-UNT-0001' LIMIT 1),
    'Documentación de sesiones',
    'Redacción de actas de las sesiones del proyecto',
    '2023-02-28'::date, '2023-02-20'::date,
    'COMPLETED', false,
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%thalia%' LIMIT 1)
);
