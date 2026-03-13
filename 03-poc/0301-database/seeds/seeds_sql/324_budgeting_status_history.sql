-- =============================================================================
-- SEEDS: Status History for EP-009 Workflow
-- =============================================================================
-- Purpose: Complete workflow tracking for budget validation process
-- Source: Based on existing budgets and assignments
-- Dependencies: budgeting.trn_monthly_budgets, budgeting.trn_resource_assignments, base.mst_users
-- =============================================================================

INSERT INTO budgeting.log_status_history (
    id, budget_id, assignment_id, record_type, old_status, new_status, 
    workflow_step, change_reason, assigned_to, changed_by
) VALUES
-- Budget creation and initial draft
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets LIMIT 1),
    NULL,
    'budget',
    NULL,
    'draft',
    'draft',
    'Budget created for January 2025 planning',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- Assignment validation
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets LIMIT 1),
    (SELECT id FROM budgeting.trn_resource_assignments LIMIT 1),
    'assignment',
    'draft',
    'validated',
    'validated',
    'Skills validated for development tasks',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- Budget validation
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets LIMIT 1),
    NULL,
    'budget',
    'draft',
    'validated',
    'validated',
    'Budget validated after resource assignments review',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
)
ON CONFLICT DO NOTHING;

SELECT 'Status history records inserted:' as status, COUNT(*) as total_history FROM budgeting.log_status_history;
