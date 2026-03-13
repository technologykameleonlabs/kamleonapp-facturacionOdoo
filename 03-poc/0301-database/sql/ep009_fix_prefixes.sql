-- =============================================================================
-- EP-009 CORRECCIÓN: Renombrar tablas con prefijos correctos
-- =============================================================================
-- Purpose: Rename EP-009 tables to use correct prefixes (trn_, log_)
-- This script fixes the naming convention for budgeting schema tables
-- =============================================================================

-- Rename tables to correct prefixes
ALTER TABLE budgeting.monthly_budgets RENAME TO trn_monthly_budgets;
ALTER TABLE budgeting.resource_assignments RENAME TO trn_resource_assignments;
ALTER TABLE budgeting.cost_calculations RENAME TO trn_cost_calculations;
ALTER TABLE budgeting.budget_versions RENAME TO log_budget_versions;
ALTER TABLE budgeting.status_history RENAME TO log_status_history;

-- Update foreign key constraints to use new table names
ALTER TABLE budgeting.trn_resource_assignments 
DROP CONSTRAINT IF EXISTS resource_assignments_budget_id_fkey,
ADD CONSTRAINT fk_trn_resource_assignments_budget_id 
FOREIGN KEY (budget_id) REFERENCES budgeting.trn_monthly_budgets(id) ON DELETE CASCADE;

ALTER TABLE budgeting.trn_cost_calculations 
DROP CONSTRAINT IF EXISTS cost_calculations_assignment_id_fkey,
ADD CONSTRAINT fk_trn_cost_calculations_assignment_id 
FOREIGN KEY (assignment_id) REFERENCES budgeting.trn_resource_assignments(id) ON DELETE CASCADE;

ALTER TABLE budgeting.log_budget_versions 
DROP CONSTRAINT IF EXISTS budget_versions_budget_id_fkey,
ADD CONSTRAINT fk_log_budget_versions_budget_id 
FOREIGN KEY (budget_id) REFERENCES budgeting.trn_monthly_budgets(id) ON DELETE CASCADE;

ALTER TABLE budgeting.log_status_history 
DROP CONSTRAINT IF EXISTS status_history_budget_id_fkey,
ADD CONSTRAINT fk_log_status_history_budget_id 
FOREIGN KEY (budget_id) REFERENCES budgeting.trn_monthly_budgets(id) ON DELETE CASCADE;

ALTER TABLE budgeting.log_status_history 
DROP CONSTRAINT IF EXISTS status_history_assignment_id_fkey,
ADD CONSTRAINT fk_log_status_history_assignment_id 
FOREIGN KEY (assignment_id) REFERENCES budgeting.trn_resource_assignments(id) ON DELETE CASCADE;

-- Update indexes to use new table names (these will be recreated automatically)
DROP INDEX IF EXISTS budgeting.idx_monthly_budgets_project_month;
DROP INDEX IF EXISTS budgeting.idx_monthly_budgets_status_date;
DROP INDEX IF EXISTS budgeting.idx_monthly_budgets_currency;
DROP INDEX IF EXISTS budgeting.idx_resource_assignments_budget_employee;
DROP INDEX IF EXISTS budgeting.idx_resource_assignments_employee_month;
DROP INDEX IF EXISTS budgeting.idx_resource_assignments_status_active;

-- Recreate indexes with correct table names
CREATE INDEX IF NOT EXISTS idx_trn_monthly_budgets_project_month 
ON budgeting.trn_monthly_budgets(project_id, budget_month);

CREATE INDEX IF NOT EXISTS idx_trn_monthly_budgets_status_date 
ON budgeting.trn_monthly_budgets(status, created_at);

CREATE INDEX IF NOT EXISTS idx_trn_monthly_budgets_currency 
ON budgeting.trn_monthly_budgets(currency);

CREATE INDEX IF NOT EXISTS idx_trn_resource_assignments_budget_employee 
ON budgeting.trn_resource_assignments(budget_id, employee_id);

CREATE INDEX IF NOT EXISTS idx_trn_resource_assignments_employee_month 
ON budgeting.trn_resource_assignments(employee_id, created_at);

CREATE INDEX IF NOT EXISTS idx_trn_resource_assignments_status_active 
ON budgeting.trn_resource_assignments(status, updated_at);

-- Verification: List renamed tables
SELECT 'Tables renamed successfully' as status, 
       schemaname, tablename 
FROM pg_tables 
WHERE schemaname = 'budgeting' 
ORDER BY tablename;
