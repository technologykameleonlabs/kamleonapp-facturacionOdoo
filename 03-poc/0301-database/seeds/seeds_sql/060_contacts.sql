-- Seeds for masterdata.mst_contacts
-- Generated from sources/contacts

INSERT INTO masterdata.mst_contacts (
    id,
    contact_code,
    company_name,
    contact_type,
    email,
    phone,
    address,
    country,
    economic_sector,
    is_active,
    created_at,
    updated_at,
    created_by,
    updated_by
) VALUES
-- Mojito360 S.L.
(
    gen_random_uuid(),
    'CNT-MOJ-001',
    'Mojito360 S.L.',
    'empresa'::masterdata.contact_type_enum,
    'contacto@mojito360.com',
    '+34 600 123 456',
    'Calle Innovación 456, Barcelona, Spain',
    'Spain',
    'Tecnología',
    true,
    NOW(),
    NOW(),
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- Unitraffic Salud S.L.
(
    gen_random_uuid(),
    'CNT-UNT-002',
    'Unitraffic Salud S.L.',
    'empresa'::masterdata.contact_type_enum,
    'contacto@unitraffic.com',
    '+34 600 789 012',
    'Calle Salud 123, Madrid, Spain',
    'Spain',
    'Salud',
    true,
    NOW(),
    NOW(),
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- AscendLabs OÜ
(
    gen_random_uuid(),
    'CNT-ASC-003',
    'AscendLabs OÜ',
    'empresa'::masterdata.contact_type_enum,
    'contacto@ascendlabs.ee',
    '+372 5123 4567',
    'Harju maakond, Tallinn, Estonia',
    'Estonia',
    'Tecnología',
    true,
    NOW(),
    NOW(),
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- Commercecrat LLC
(
    gen_random_uuid(),
    'CNT-COM-004',
    'Commercecrat LLC',
    'empresa'::masterdata.contact_type_enum,
    'contacto@commercecrat.com',
    '+1 555 123 4567',
    '123 Business St, New York, USA',
    'United States',
    'Comercio Electrónico',
    true,
    NOW(),
    NOW(),
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
)
ON CONFLICT (contact_code) DO UPDATE SET
    company_name = EXCLUDED.company_name,
    email = EXCLUDED.email,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    country = EXCLUDED.country,
    economic_sector = EXCLUDED.economic_sector,
    updated_at = NOW(),
    updated_by = EXCLUDED.updated_by;

