-- =====================================================
-- SEEDS: Entidades Base
-- =====================================================
-- Poblar base.mst_entities con las entidades principales
-- =====================================================

INSERT INTO base.mst_entities (
    id,
    name,
    description,
    tax_id,
    address,
    phone,
    email,
    website,
    is_active,
    multi_tenant_config,
    created_at,
    updated_at
) VALUES
-- KameleonLabs
(
    gen_random_uuid(),
    'KameleonLabs',
    'Empresa de desarrollo de software y consultoría tecnológica',
    'B12345678',
    'Calle Tecnología 123, Madrid, Spain',
    '+34 911 123 456',
    'info@kameleonlabs.ai',
    'https://kameleonlabs.ai',
    true,
    '{"enabled": true, "features": ["projects", "time_tracking", "analytics"]}',
    now(),
    now()
),
-- Mojito360
(
    gen_random_uuid(),
    'Mojito360',
    'Empresa de desarrollo de software y soluciones digitales',
    'B87654321',
    'Calle Innovación 456, Barcelona, Spain',
    '+34 933 654 321',
    'info@mojito360.com',
    'https://mojito360.com',
    true,
    '{"enabled": true, "features": ["projects", "time_tracking", "analytics"]}',
    now(),
    now()
)
ON CONFLICT DO NOTHING;
