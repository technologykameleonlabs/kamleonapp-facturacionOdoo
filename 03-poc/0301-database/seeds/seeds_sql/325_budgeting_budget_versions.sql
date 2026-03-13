-- =============================================================================
-- SEEDS: Budget Versions for EP-009
-- =============================================================================
-- Purpose: Version control for budget changes and analytics
-- Source: Based on existing budgets with version history
-- Dependencies: budgeting.trn_monthly_budgets, base.mst_users
-- =============================================================================

INSERT INTO budgeting.log_budget_versions (
    id, budget_id, version_number, raw_data, change_reason, created_by
) VALUES
-- Version 1 - Initial budget
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets LIMIT 1),
    1,
    '{}'::jsonb,
    'Initial budget creation for January 2025',
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- Version 2 - After adjustments
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets LIMIT 1),
    2,
    '{}'::jsonb,
    'Added DevOps specialist and adjusted costs',
    (SELECT id FROM base.mst_users LIMIT 1)
)
ON CONFLICT DO NOTHING;

SELECT 'Budget versions inserted:' as status, COUNT(*) as total_versions FROM budgeting.log_budget_versions;
