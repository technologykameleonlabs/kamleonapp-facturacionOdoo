-- SEEDS PARA discord.trn_channels
-- Canales Discord asociados a proyectos existentes

-- Canales para proyectos de Mojito360
INSERT INTO discord.trn_channels (id, name, project_id, type_id, discord_channel_id, status)
VALUES
    (
        gen_random_uuid(),
        'proj-prj-moj-0007',
        (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0007' LIMIT 1),
        (SELECT id FROM discord.mst_channel_types WHERE code = 'project' LIMIT 1),
        'dc-moj-0007-' || substring(substring(gen_random_uuid()::text, 1, 8), 1, 8),
        'active'
    ),
    (
        gen_random_uuid(),
        'proj-prj-moj-0002',
        (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0002' LIMIT 1),
        (SELECT id FROM discord.mst_channel_types WHERE code = 'project' LIMIT 1),
        'dc-moj-0002-' || substring(substring(gen_random_uuid()::text, 1, 8), 1, 8),
        'active'
    ),
    (
        gen_random_uuid(),
        'proj-prj-moj-0006',
        (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-MOJ-0006' LIMIT 1),
        (SELECT id FROM discord.mst_channel_types WHERE code = 'project' LIMIT 1),
        'dc-moj-0006-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    )
ON CONFLICT DO NOTHING;

-- Canales para proyectos de LogicPlaces
INSERT INTO discord.trn_channels (id, name, project_id, type_id, discord_channel_id, status)
VALUES
    (
        gen_random_uuid(),
        'proj-prj-log-0005',
        (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-LOG-0005' LIMIT 1),
        (SELECT id FROM discord.mst_channel_types WHERE code = 'project' LIMIT 1),
        'dc-log-0005-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    ),
    (
        gen_random_uuid(),
        'proj-prj-log-0004',
        (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-LOG-0004' LIMIT 1),
        (SELECT id FROM discord.mst_channel_types WHERE code = 'project' LIMIT 1),
        'dc-log-0004-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    )
ON CONFLICT DO NOTHING;

-- Canales para proyectos de KameleonLabs
INSERT INTO discord.trn_channels (id, name, project_id, type_id, discord_channel_id, status)
VALUES
    (
        gen_random_uuid(),
        'proj-prj-klm-0003',
        (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0003' LIMIT 1),
        (SELECT id FROM discord.mst_channel_types WHERE code = 'project' LIMIT 1),
        'dc-klm-0003-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    ),
    (
        gen_random_uuid(),
        'proj-prj-klm-0027',
        (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0027' LIMIT 1),
        (SELECT id FROM discord.mst_channel_types WHERE code = 'project' LIMIT 1),
        'dc-klm-0027-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    ),
    (
        gen_random_uuid(),
        'proj-prj-klm-0031',
        (SELECT id FROM projects.trn_projects WHERE code = 'PRJ-KLM-0031' LIMIT 1),
        (SELECT id FROM discord.mst_channel_types WHERE code = 'project' LIMIT 1),
        'dc-klm-0031-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    )
ON CONFLICT DO NOTHING;

-- Canales generales (sin proyecto específico)
INSERT INTO discord.trn_channels (id, name, type_id, discord_channel_id, status)
VALUES
    (
        gen_random_uuid(),
        'general-announcements',
        (SELECT id FROM discord.mst_channel_types WHERE code = 'announcements' LIMIT 1),
        'dc-announcements-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    ),
    (
        gen_random_uuid(),
        'general-support',
        (SELECT id FROM discord.mst_channel_types WHERE code = 'support' LIMIT 1),
        'dc-support-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    ),
    (
        gen_random_uuid(),
        'general-random',
        (SELECT id FROM discord.mst_channel_types WHERE code = 'random' LIMIT 1),
        'dc-random-' || substring(gen_random_uuid()::text, 1, 8),
        'active'
    )
ON CONFLICT DO NOTHING;

-- Vincular canales a proyectos (actualizar tabla projects)
UPDATE projects.trn_projects
SET discord_channel_id = (
    SELECT dc.id
    FROM discord.trn_channels dc
    WHERE dc.project_id = projects.trn_projects.id
    LIMIT 1
)
WHERE discord_channel_id IS NULL
AND EXISTS (
    SELECT 1 FROM discord.trn_channels dc
    WHERE dc.project_id = projects.trn_projects.id
);

-- Verificación de inserciones
SELECT 'Canales Discord creados:' as verification;
SELECT
    dc.name as channel_name,
    dc.status,
    p.code as project_code,
    ct.name as channel_type,
    dc.discord_channel_id
FROM discord.trn_channels dc
LEFT JOIN projects.trn_projects p ON dc.project_id = p.id
JOIN discord.mst_channel_types ct ON dc.type_id = ct.id
ORDER BY dc.created_at DESC;
