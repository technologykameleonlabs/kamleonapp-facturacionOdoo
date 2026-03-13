-- =============================================================================
-- SEEDS: Resource Assignments for EP-009
-- =============================================================================
-- Purpose: Employee assignments to project budgets
-- Source: Based on existing budgets and employees
-- Dependencies: budgeting.trn_monthly_budgets, masterdata.mst_employees, base.mst_users
-- =============================================================================

INSERT INTO budgeting.trn_resource_assignments (
    id, budget_id, employee_id, dedication_percentage, monthly_cost, 
    status, validation_notes, skills_validated, created_by, updated_by
) VALUES
-- Assignment for first budget
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets LIMIT 1),
    (SELECT id FROM masterdata.mst_employees LIMIT 1),
    80.00,
    4800.00,
    'validated',
    'Senior developer assigned to core development tasks',
    true,
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- Second assignment for first budget
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets LIMIT 1),
    (SELECT id FROM masterdata.mst_employees LIMIT 1 OFFSET 1),
    60.00,
    3600.00,
    'validated',
    'QA engineer for testing and quality assurance',
    true,
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
),
-- Assignment for second budget
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets LIMIT 1 OFFSET 1),
    (SELECT id FROM masterdata.mst_employees LIMIT 1 OFFSET 2),
    100.00,
    6000.00,
    'pending_validation',
    'Full-time project manager assignment',
    false,
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
)
ON CONFLICT DO NOTHING;

SELECT 'Resource assignments inserted:' as status, COUNT(*) as total_assignments FROM budgeting.trn_resource_assignments;
