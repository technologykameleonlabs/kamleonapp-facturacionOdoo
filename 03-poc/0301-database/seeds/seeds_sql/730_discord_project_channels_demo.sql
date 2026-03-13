-- DEMO DE LA FUNCIÓN discord.create_project_channel
-- Demostración de creación automática de canales para proyectos

-- Crear un proyecto de ejemplo para la demo
INSERT INTO projects.trn_projects (
    id,
    entity_id,
    type_id,
    owner_id,
    created_by,
    updated_by,
    code,
    name,
    description,
    priority,
    status,
    planned_start_date,
    planned_end_date,
    budget,
    progress_percentage,
    is_active
) VALUES (
    gen_random_uuid(),
    'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid, -- KameleonLabs
    (SELECT id FROM projects.mst_project_types WHERE name = 'Product - Web App' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
    'PRJ-KLM-DEMO-001',
    'Demo Discord Integration',
    'Proyecto de demostración para integración con Discord',
    'MEDIUM',
    'IN_PROGRESS',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '30 days',
    15000.00,
    0.00,
    true
) ON CONFLICT DO NOTHING;

-- Demo: Crear proyecto y canal usando la función
DO $$
DECLARE
    demo_project_id uuid;
    created_channel_id uuid;
BEGIN
    -- Crear proyecto demo
    INSERT INTO projects.trn_projects (
        id,
        entity_id,
        type_id,
        owner_id,
        created_by,
        updated_by,
        code,
        name,
        description,
        priority,
        status,
        planned_start_date,
        planned_end_date,
        budget,
        progress_percentage,
        is_active
    ) VALUES (
        gen_random_uuid(),
        'a14e7057-7027-4cf0-ba98-475755a67e5e'::uuid,
        (SELECT id FROM projects.mst_project_types WHERE name = 'Product - Web App' LIMIT 1),
        (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
        (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
        (SELECT id FROM base.mst_users WHERE email LIKE '%julio%' LIMIT 1),
        'PRJ-KLM-DEMO-001',
        'Demo Discord Integration',
        'Proyecto de demostración para integración con Discord',
        'MEDIUM',
        'IN_PROGRESS',
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '30 days',
        15000.00,
        0.00,
        true
    )
    ON CONFLICT DO NOTHING;

    -- Obtener ID del proyecto
    SELECT id INTO demo_project_id
    FROM projects.trn_projects
    WHERE code = 'PRJ-KLM-DEMO-001'
    LIMIT 1;

    -- Crear canal usando la función
    IF demo_project_id IS NOT NULL THEN
        SELECT discord.create_project_channel(demo_project_id, 'PRJ-KLM-DEMO-001')
        INTO created_channel_id;

        RAISE NOTICE 'Canal creado exitosamente: %', created_channel_id;
    END IF;
END $$;

-- Verificación completa de la integración
SELECT '=== VERIFICACIÓN COMPLETA DE LA INTEGRACIÓN ===' as section;

-- 1. Proyectos con canales Discord
SELECT '1. Proyectos con canales Discord:' as verification;
SELECT
    p.code as project_code,
    p.name as project_name,
    dc.name as channel_name,
    dc.status as channel_status,
    COUNT(dcm.user_id) as member_count
FROM projects.trn_projects p
LEFT JOIN discord.trn_channels dc ON p.discord_channel_id = dc.id
LEFT JOIN discord.rel_channel_members dcm ON dc.id = dcm.channel_id
WHERE p.discord_channel_id IS NOT NULL
GROUP BY p.id, p.code, p.name, dc.name, dc.status
ORDER BY p.code;

-- 2. Canales por tipo
SELECT '2. Canales por tipo:' as verification;
SELECT
    ct.name as channel_type,
    COUNT(dc.id) as channel_count,
    COUNT(dcm.user_id) as total_members
FROM discord.mst_channel_types ct
LEFT JOIN discord.trn_channels dc ON ct.id = dc.type_id
LEFT JOIN discord.rel_channel_members dcm ON dc.id = dcm.channel_id
GROUP BY ct.id, ct.name
ORDER BY ct.name;

-- 3. Estadísticas generales
SELECT '3. Estadísticas generales:' as verification;
SELECT
    (SELECT COUNT(*) FROM discord.mst_channel_types) as total_channel_types,
    (SELECT COUNT(*) FROM discord.trn_channels) as total_channels,
    (SELECT COUNT(*) FROM discord.rel_channel_members) as total_memberships,
    (SELECT COUNT(*) FROM projects.trn_projects WHERE discord_channel_id IS NOT NULL) as projects_with_channels;

-- 4. Canales activos con miembros
SELECT '4. Canales activos con miembros:' as verification;
SELECT
    dc.name as channel_name,
    ct.name as channel_type,
    p.code as project_code,
    COUNT(dcm.user_id) as member_count,
    STRING_AGG(u.email, ', ') as member_emails
FROM discord.trn_channels dc
JOIN discord.mst_channel_types ct ON dc.type_id = ct.id
LEFT JOIN projects.trn_projects p ON dc.project_id = p.id
LEFT JOIN discord.rel_channel_members dcm ON dc.id = dcm.channel_id
LEFT JOIN base.mst_users u ON dcm.user_id = u.id
WHERE dc.status = 'active'
GROUP BY dc.id, dc.name, ct.name, p.code
ORDER BY dc.name;

-- 5. Función disponible y lista para usar
SELECT '5. Función create_project_channel:' as verification;
SELECT
    proname as function_name,
    pg_get_function_identity_arguments(oid) as parameters,
    obj_description(oid, 'pg_proc') as description
FROM pg_proc
WHERE proname = 'create_project_channel'
AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'discord');
