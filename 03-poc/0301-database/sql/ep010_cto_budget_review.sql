-- =============================================================================
-- EP-010: REVISIÓN PRESUPUESTARIA POR CTO
-- =============================================================================
-- Purpose: Extend existing EP-009 tables for CTO review capabilities
-- Dependencies: EP-009 tables in budgeting schema
-- Tables extended: trn_monthly_budgets, trn_resource_assignments, log_status_history
-- =============================================================================

-- =============================================================================
-- EXTENSIONS TO EXISTING TABLES
-- =============================================================================

-- Extend budgeting.trn_monthly_budgets for CTO review workflow
ALTER TABLE budgeting.trn_monthly_budgets
ADD COLUMN IF NOT EXISTS cto_review_status text DEFAULT 'pending' 
    CHECK (cto_review_status IN ('pending', 'in_review', 'capacity_analyzed', 'corrections_applied', 'technically_validated', 'escalated_to_executive')),
ADD COLUMN IF NOT EXISTS capacity_risk_level text DEFAULT 'unknown' 
    CHECK (capacity_risk_level IN ('unknown', 'low', 'medium', 'high', 'critical')),
ADD COLUMN IF NOT EXISTS technical_validation_date timestamptz,
ADD COLUMN IF NOT EXISTS cto_reviewer_id uuid REFERENCES base.mst_users(id),
ADD COLUMN IF NOT EXISTS capacity_analysis jsonb DEFAULT '{}',
ADD COLUMN IF NOT EXISTS technical_report jsonb DEFAULT '{}',
ADD COLUMN IF NOT EXISTS escalation_status text DEFAULT 'pending' 
    CHECK (escalation_status IN ('pending', 'escalated', 'approved', 'rejected'));

COMMENT ON COLUMN budgeting.trn_monthly_budgets.cto_review_status IS 'EP-010: Current status in CTO review workflow';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.capacity_risk_level IS 'EP-010-US-002: Overall capacity risk level for this budget';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.technical_validation_date IS 'EP-010-US-004: When CTO completed technical validation';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.cto_reviewer_id IS 'EP-010: CTO user who is reviewing this budget';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.capacity_analysis IS 'EP-010-US-002: Detailed capacity analysis results in JSON';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.technical_report IS 'EP-010-US-004: Technical validation report in JSON';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.escalation_status IS 'EP-010-US-005: Status of escalation to executive approval';

-- Extend budgeting.trn_resource_assignments for CTO corrections
ALTER TABLE budgeting.trn_resource_assignments
ADD COLUMN IF NOT EXISTS capacity_score numeric(5,2) DEFAULT 100.00,
ADD COLUMN IF NOT EXISTS cto_correction_notes text,
ADD COLUMN IF NOT EXISTS technical_validation_status text DEFAULT 'pending' 
    CHECK (technical_validation_status IN ('pending', 'validated', 'rejected', 'corrected')),
ADD COLUMN IF NOT EXISTS original_dedication_percentage numeric(5,2),
ADD COLUMN IF NOT EXISTS corrected_dedication_percentage numeric(5,2);

COMMENT ON COLUMN budgeting.trn_resource_assignments.capacity_score IS 'EP-010-US-002: Capacity utilization score (100 = optimal)';
COMMENT ON COLUMN budgeting.trn_resource_assignments.cto_correction_notes IS 'EP-010-US-003: Notes from CTO corrections';
COMMENT ON COLUMN budgeting.trn_resource_assignments.technical_validation_status IS 'EP-010-US-004: Technical validation status for this assignment';
COMMENT ON COLUMN budgeting.trn_resource_assignments.original_dedication_percentage IS 'EP-010-US-003: Original dedication before CTO corrections';
COMMENT ON COLUMN budgeting.trn_resource_assignments.corrected_dedication_percentage IS 'EP-010-US-003: Corrected dedication after CTO review';

-- Extend budgeting.log_status_history for CTO workflow tracking
ALTER TABLE budgeting.log_status_history
ADD COLUMN IF NOT EXISTS cto_reviewer_id uuid REFERENCES base.mst_users(id);

COMMENT ON COLUMN budgeting.log_status_history.cto_reviewer_id IS 'EP-010: CTO who performed this workflow action';

-- Update CHECK constraint to include new workflow steps
ALTER TABLE budgeting.log_status_history 
DROP CONSTRAINT IF EXISTS log_status_history_workflow_step_check;

ALTER TABLE budgeting.log_status_history 
ADD CONSTRAINT log_status_history_workflow_step_check 
CHECK (workflow_step IN (
    'draft', 'pending_validation', 'validated', 'submitted_to_cto', 'approved', 'rejected',
    'capacity_analysis', 'technical_validation', 'escalation'
));

-- =============================================================================
-- INDEXES FOR PERFORMANCE (CTO QUERIES)
-- =============================================================================

-- Indexes for CTO dashboard queries
CREATE INDEX IF NOT EXISTS idx_trn_monthly_budgets_cto_review_status 
ON budgeting.trn_monthly_budgets(cto_review_status, budget_month);

CREATE INDEX IF NOT EXISTS idx_trn_monthly_budgets_capacity_risk 
ON budgeting.trn_monthly_budgets(capacity_risk_level, budget_month);

CREATE INDEX IF NOT EXISTS idx_trn_monthly_budgets_cto_reviewer 
ON budgeting.trn_monthly_budgets(cto_reviewer_id, cto_review_status);

-- Indexes for resource assignment corrections
CREATE INDEX IF NOT EXISTS idx_trn_resource_assignments_capacity_score 
ON budgeting.trn_resource_assignments(capacity_score);

CREATE INDEX IF NOT EXISTS idx_trn_resource_assignments_technical_validation 
ON budgeting.trn_resource_assignments(technical_validation_status, budget_id);

-- Indexes for workflow history
CREATE INDEX IF NOT EXISTS idx_log_status_history_cto_reviewer 
ON budgeting.log_status_history(cto_reviewer_id, created_at) WHERE cto_reviewer_id IS NOT NULL;
