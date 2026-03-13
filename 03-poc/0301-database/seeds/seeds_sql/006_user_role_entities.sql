-- Asignaciones detalladas de usuarios a roles y entidades
-- Algunos usuarios tendrán roles adicionales para demostrar la flexibilidad
INSERT INTO base.rel_user_role_entities (
    user_id,
    role_id,
    entity_id
) VALUES
-- KameleonLabs: Asignaciones principales
('550e8400-e29b-41d4-a716-446655440001'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Administrador'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440002'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Director'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440003'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'CTO'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440004'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Project Manager'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440005'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Project Manager'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440006'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440007'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440008'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440009'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440010'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440011'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440012'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440013'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440014'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440015'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440016'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440017'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Miembro del equipo'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),

-- Mojito360: Asignaciones principales
('550e8400-e29b-41d4-a716-446655440018'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Administrador'), (SELECT id FROM base.mst_entities WHERE name = 'Mojito360')),

-- Asignaciones adicionales (roles múltiples)
-- El CTO también puede ser Project Manager en algunos proyectos
('550e8400-e29b-41d4-a716-446655440003'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Project Manager'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
-- Algunos miembros del equipo también pueden ser Project Managers
('550e8400-e29b-41d4-a716-446655440006'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Project Manager'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs')),
('550e8400-e29b-41d4-a716-446655440007'::uuid, (SELECT id FROM base.mst_roles WHERE name = 'Project Manager'), (SELECT id FROM base.mst_entities WHERE name = 'KameleonLabs'));