-- =============================================================================
-- SEEDS: Monthly Budgets for EP-009
-- =============================================================================
-- Purpose: Sample monthly budgets for existing projects
-- Source: Based on existing projects with realistic budget data
-- Dependencies: projects.trn_projects, base.mst_users
-- =============================================================================

INSERT INTO budgeting.trn_monthly_budgets (
    id, project_id, budget_month, currency, status, total_cost, total_margin, 
    target_margin, validation_notes, created_by, updated_by
) VALUES
-- Budget for first active project
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE is_active = true LIMIT 1),
    '2025-01-01'::date,
    'EUR',
    'draft',
    15000.00,
    2250.00,
    15.00,
    'Initial budget draft for January 2025',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- Budget for second active project
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE is_active = true LIMIT 1 OFFSET 1),
    '2025-02-01'::date,
    'EUR',
    'pending_validation',
    18000.00,
    3600.00,
    20.00,
    'Budget ready for validation - February planning',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- International project budget
(
    gen_random_uuid(),
    (SELECT id FROM projects.trn_projects WHERE is_active = true LIMIT 1 OFFSET 2),
    '2025-03-01'::date,
    'USD',
    'validated',
    25000.00,
    6250.00,
    25.00,
    'Validated budget for international project',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
)
ON CONFLICT DO NOTHING;

SELECT 'Monthly budgets inserted:' as status, COUNT(*) as total_budgets FROM budgeting.trn_monthly_budgets;
