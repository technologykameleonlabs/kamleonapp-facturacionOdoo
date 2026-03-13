-- SEEDS PARA discord.rel_channel_members
-- Miembros de canales Discord

-- Función auxiliar para obtener ID de usuario por email
CREATE OR REPLACE FUNCTION get_user_id_by_email(email_pattern text)
RETURNS uuid AS $$
BEGIN
    RETURN (SELECT id FROM base.mst_users WHERE email LIKE '%' || email_pattern || '%' LIMIT 1);
END;
$$ LANGUAGE plpgsql;

-- Miembros para canales de proyectos Mojito360
INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('julio'),
    now()
FROM discord.trn_channels dc
WHERE dc.name LIKE 'proj-prj-moj-%'
ON CONFLICT (channel_id, user_id) DO NOTHING;

INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('luis'),
    now()
FROM discord.trn_channels dc
WHERE dc.name LIKE 'proj-prj-moj-%'
ON CONFLICT (channel_id, user_id) DO NOTHING;

-- Miembros para canales de proyectos LogicPlaces
INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('amalia'),
    now()
FROM discord.trn_channels dc
WHERE dc.name LIKE 'proj-prj-log-%'
ON CONFLICT (channel_id, user_id) DO NOTHING;

INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('julio'),
    now()
FROM discord.trn_channels dc
WHERE dc.name LIKE 'proj-prj-log-%'
ON CONFLICT (channel_id, user_id) DO NOTHING;

-- Miembros para canales de proyectos KameleonLabs
INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('luis'),
    now()
FROM discord.trn_channels dc
WHERE dc.name LIKE 'proj-prj-klm-0003'
ON CONFLICT (channel_id, user_id) DO NOTHING;

INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('osbel'),
    now()
FROM discord.trn_channels dc
WHERE dc.name LIKE 'proj-prj-klm-0027'
ON CONFLICT (channel_id, user_id) DO NOTHING;

INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('julio'),
    now()
FROM discord.trn_channels dc
WHERE dc.name LIKE 'proj-prj-klm-0031'
ON CONFLICT (channel_id, user_id) DO NOTHING;

-- Miembros para canales generales (todos los usuarios activos)
INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    u.id,
    now()
FROM discord.trn_channels dc
CROSS JOIN base.mst_users u
WHERE dc.name LIKE 'general-%'
ON CONFLICT (channel_id, user_id) DO NOTHING;

-- Miembros adicionales para proyectos específicos
-- Proyecto Document Insights Extractor - Equipo técnico
INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('luis'),
    now()
FROM discord.trn_channels dc
WHERE dc.name = 'proj-prj-klm-0003'
UNION ALL
SELECT
    dc.id,
    get_user_id_by_email('osbel'),
    now()
FROM discord.trn_channels dc
WHERE dc.name = 'proj-prj-klm-0003'
UNION ALL
SELECT
    dc.id,
    get_user_id_by_email('adrian'),
    now()
FROM discord.trn_channels dc
WHERE dc.name = 'proj-prj-klm-0003'
ON CONFLICT (channel_id, user_id) DO NOTHING;

-- Proyecto Mojito BI Platform - Equipo completo
INSERT INTO discord.rel_channel_members (channel_id, user_id, joined_at)
SELECT
    dc.id,
    get_user_id_by_email('osbel'),
    now()
FROM discord.trn_channels dc
WHERE dc.name = 'proj-prj-klm-0027'
UNION ALL
SELECT
    dc.id,
    get_user_id_by_email('julio'),
    now()
FROM discord.trn_channels dc
WHERE dc.name = 'proj-prj-klm-0027'
UNION ALL
SELECT
    dc.id,
    get_user_id_by_email('amalia'),
    now()
FROM discord.trn_channels dc
WHERE dc.name = 'proj-prj-klm-0027'
UNION ALL
SELECT
    dc.id,
    get_user_id_by_email('laura'),
    now()
FROM discord.trn_channels dc
WHERE dc.name = 'proj-prj-klm-0027'
ON CONFLICT (channel_id, user_id) DO NOTHING;

-- Limpiar función auxiliar
DROP FUNCTION IF EXISTS get_user_id_by_email(text);

-- Verificación de inserciones
SELECT 'Miembros de canales Discord:' as verification;
SELECT
    dc.name as channel_name,
    COUNT(dcm.user_id) as member_count,
    STRING_AGG(u.email, ', ') as members
FROM discord.trn_channels dc
LEFT JOIN discord.rel_channel_members dcm ON dc.id = dcm.channel_id
LEFT JOIN base.mst_users u ON dcm.user_id = u.id
GROUP BY dc.id, dc.name
ORDER BY dc.name;
