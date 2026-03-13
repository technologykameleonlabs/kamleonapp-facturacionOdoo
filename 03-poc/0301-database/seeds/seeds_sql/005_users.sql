-- Crear usuarios en auth.users primero (con manejo de conflictos)
INSERT INTO auth.users (
    id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_user_meta_data
) VALUES
-- KameleonLabs employees
('550e8400-e29b-41d4-a716-446655440001'::uuid, 'adrian@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Adrián Ávila Morales", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440002'::uuid, 'amalia@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Amalia Jacomino Lorenzo", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440003'::uuid, 'armando@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Armando Baños Pascual", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440004'::uuid, 'elias@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Carlos Elías González Valdés", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440005'::uuid, 'david@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "David Díaz Martínez", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440006'::uuid, 'guillermo@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Guillermo Águila Crespo", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440007'::uuid, 'julio@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Julio García Martínez", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440008'::uuid, 'laura@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Laura Elena Santana Rojas", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440009'::uuid, 'luisenrique@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Luis Enrique Saborit", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440010'::uuid, 'manuel@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Manuel Quesada Martínez", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440011'::uuid, 'michel@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Michel Pérez Saavedra", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440012'::uuid, 'nelson@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Nelson Sánchez Álvarez", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440013'::uuid, 'osbel@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Osbel Montero", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440014'::uuid, 'pedro@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Pedro Romero López", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440015'::uuid, 'rene@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "René Espinosa", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440016'::uuid, 'rogeidis@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Rogeidis Sifontes Llerena", "entity": "KameleonLabs"}'::jsonb),
('550e8400-e29b-41d4-a716-446655440017'::uuid, 'thalia@kameleonlabs.ai', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Thalia Amos Machado", "entity": "KameleonLabs"}'::jsonb),
-- Mojito360 employees
('550e8400-e29b-41d4-a716-446655440018'::uuid, 'julgarcia@mojito360.com', '$2a$10$test12345678901234567890', now(), now(), now(), '{"name": "Julio García Martínez", "entity": "Mojito360"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    raw_user_meta_data = EXCLUDED.raw_user_meta_data,
    updated_at = now();

-- Ahora crear los usuarios en base.mst_users (solo campos que existen en la tabla)
INSERT INTO base.mst_users (
    id,
    role_id,
    avatar_url,
    bio
) VALUES
-- KameleonLabs employees (Administrator: Adrián, Director: Amalia, CTO: Armando, Project Managers: Elias, David, Miembros: resto)
('550e8400-e29b-41d4-a716-446655440001'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Administrador'), NULL, 'Administrador de KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440002'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Director'), NULL, 'Director de KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440003'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'CTO'), NULL, 'CTO de KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440004'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Project Manager'), NULL, 'Project Manager en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440005'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Project Manager'), NULL, 'Project Manager en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440006'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440007'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440008'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440009'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440010'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440011'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440012'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440013'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440014'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440015'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440016'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
('550e8400-e29b-41d4-a716-446655440017'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), NULL, 'Miembro del equipo en KameleonLabs'),
-- Mojito360 employees (Administrator)
('550e8400-e29b-41d4-a716-446655440018'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Administrador'), NULL, 'Administrador de Mojito360')
ON CONFLICT (id) DO UPDATE SET
    role_id = EXCLUDED.role_id,
    bio = EXCLUDED.bio;