-- SEEDS COMPLETOS PARA projects.trn_projects - TODOS LOS PROYECTOS FUENTE
-- Basados en @projects con mapeo correcto de entidades

INSERT INTO projects.trn_projects (
    id, entity_id, type_id, owner_id, created_by, updated_by, 
    code, name, description, priority, status, 
    planned_start_date, planned_end_date, 
    budget, progress_percentage, is_active
) VALUES 
-- =========================================
-- PROYECTOS DE MOJITO360 S.L.
-- =========================================
(
    gen_random_uuid(),
    '5990ff6d-378a-4098-92cf-63917d1935df'::uuid,  -- Mojito360
    (SELECT id FROM projects.mst_project_types WHERE name = 'Service - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-MOJ-0007', 'Microservices Transition', 
    'Transición a arquitectura de microservicios para Mojito360',
    'HIGH', 'PAUSED', '2023-01-01'::date, '2024-06-30'::date,
    85000.00, 30.00, true
),
(
    gen_random_uuid(),
    '5990ff6d-378a-4098-92cf-63917d1935df'::uuid,  -- Mojito360
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - AI' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%luis%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%luis%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%luis%' LIMIT 1),
    'PRJ-MOJ-0002', 'Mojito360 AI', 
    'Implementación de soluciones de IA para Mojito360',
    'HIGH', 'COMPLETED', '2022-06-01'::date, '2023-12-31'::date,
    120000.00, 100.00, true
),
(
    gen_random_uuid(),
    '5990ff6d-378a-4098-92cf-63917d1935df'::uuid,  -- Mojito360
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-MOJ-0006', 'SourTrack', 
    'Sistema de seguimiento de flota para Mojito360',
    'MEDIUM', 'TEST', '2023-09-01'::date, '2024-03-31'::date,
    95000.00, 85.00, true
),

-- =========================================
-- PROYECTOS DE LOGICPLACES S.L.
-- =========================================
(
    gen_random_uuid(),
    '4b5b019c-f5e8-4f57-a610-af0e2c84df87'::uuid,  -- LogicPlaces
    (SELECT id FROM projects.mst_project_types WHERE name = 'Service - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-LOG-0005', 'LogicPlaces Quality', 
    'Sistema de control de calidad para LogicPlaces',
    'MEDIUM', 'PAUSED', '2023-03-01'::date, '2024-02-28'::date,
    45000.00, 60.00, true
),
(
    gen_random_uuid(),
    '4b5b019c-f5e8-4f57-a610-af0e2c84df87'::uuid,  -- LogicPlaces
    (SELECT id FROM projects.mst_project_types WHERE name = 'Service - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%amalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%amalia%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%amalia%' LIMIT 1),
    'PRJ-LOG-0004', 'LogicPlaces Design', 
    'Rediseño de interfaz para LogicPlaces',
    'LOW', 'PAUSED', '2023-07-01'::date, '2024-01-31'::date,
    35000.00, 40.00, true
),

-- =========================================
-- PROYECTOS DE UNITRAFFIC
-- =========================================
(
    gen_random_uuid(),
    '9cbef5a2-9b57-4efb-a061-5b467869990b'::uuid,  -- Unitraffic
    (SELECT id FROM projects.mst_project_types WHERE name = 'Service - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-UNT-0001', 'Unitraffic', 
    'Sistema de gestión de tráfico para Unitraffic Salud',
    'HIGH', 'COMPLETED', '2022-01-01'::date, '2023-06-30'::date,
    75000.00, 100.00, true
),

-- =========================================
-- PROYECTOS DE KAMELEONLABS (SIN ENTIDAD ESPECÍFICA)
-- =========================================
(
    gen_random_uuid(),
    'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid,  -- KameleonLabs
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%luis%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%luis%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%luis%' LIMIT 1),
    'PRJ-KLM-0003', 'Document Insights Extractor', 
    'Extractor inteligente de información de documentos',
    'HIGH', 'IN_PROGRESS', '2024-01-01'::date, '2024-08-31'::date,
    65000.00, 45.00, true
),
(
    gen_random_uuid(),
    'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid,  -- KameleonLabs
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - AI' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%osbel%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%osbel%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%osbel%' LIMIT 1),
    'PRJ-KLM-0027', 'Mojito BI Platform', 
    'Plataforma de Business Intelligence para Mojito360',
    'HIGH', 'IN_PROGRESS', '2024-02-01'::date, '2024-11-30'::date,
    95000.00, 25.00, true
),
(
    gen_random_uuid(),
    'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid,  -- KameleonLabs
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - AI' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-KLM-0011', 'Business Development', 
    'Desarrollo de nuevos negocios y oportunidades',
    'MEDIUM', 'COMPLETED', '2023-01-01'::date, '2023-12-31'::date,
    30000.00, 100.00, true
),
(
    gen_random_uuid(),
    'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid,  -- KameleonLabs
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - AI' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-KLM-0019', 'AI DMS', 
    'Sistema de gestión documental con IA',
    'MEDIUM', 'PAUSED', '2023-08-01'::date, '2024-05-31'::date,
    80000.00, 20.00, true
),
(
    gen_random_uuid(),
    'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid,  -- KameleonLabs
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - AI' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%osbel%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%osbel%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%osbel%' LIMIT 1),
    'PRJ-KLM-0022', 'Evalora.ai', 
    'Plataforma de evaluación con IA',
    'HIGH', 'IN_PROGRESS', '2024-03-01'::date, '2024-10-31'::date,
    70000.00, 35.00, true
),
(
    gen_random_uuid(),
    'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid,  -- KameleonLabs
    (SELECT id FROM projects.mst_project_types WHERE name = 'Service - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-KLM-0025', 'Textron Aviation', 
    'Proyecto para Textron Aviation',
    'MEDIUM', 'BACKLOG', '2024-06-01'::date, '2025-01-31'::date,
    200000.00, 0.00, true
),
(
    gen_random_uuid(),
    'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid,  -- KameleonLabs
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-KLM-0031', 'Nemesis', 
    'Proyecto Nemesis - Sistema avanzado',
    'HIGH', 'IN_PROGRESS', '2024-04-01'::date, '2024-12-31'::date,
    110000.00, 50.00, true
);

-- Verificación de inserciones
SELECT 'Proyectos creados:' as verification;
SELECT code, name, status, progress_percentage, budget 
FROM projects.trn_projects 
WHERE code LIKE 'PRJ-%'
ORDER BY code;
