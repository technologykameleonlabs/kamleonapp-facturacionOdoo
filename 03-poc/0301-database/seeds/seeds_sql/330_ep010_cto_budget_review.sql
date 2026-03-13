-- =============================================================================
-- SEEDS: EP-010 CTO Budget Review Extensions
-- =============================================================================
-- Purpose: Populate new EP-010 columns in existing budgeting tables
-- Dependencies: EP-009 tables (budgeting.trn_monthly_budgets, budgeting.trn_resource_assignments, budgeting.log_status_history)
-- Tables affected: 3 existing tables with new columns
-- =============================================================================

-- =============================================================================
-- SEED 1: Update existing monthly budgets with CTO workflow status
-- =============================================================================

-- Update existing budgets with CTO review status based on their current status
UPDATE budgeting.trn_monthly_budgets 
SET 
    cto_review_status = CASE 
        WHEN status IN ('draft', 'pending_validation') THEN 'pending'
        WHEN status = 'validated' THEN 'technically_validated'
        WHEN status = 'submitted_to_cto' THEN 'in_review'
        ELSE 'pending'
    END,
    capacity_risk_level = CASE 
        WHEN total_cost > 100000 THEN 'high'
        WHEN total_cost > 50000 THEN 'medium'
        ELSE 'low'
    END,
    capacity_analysis = jsonb_build_object(
        'budget_id', id,
        'analysis_date', now(),
        'risk_level', CASE 
            WHEN total_cost > 100000 THEN 'high'
            WHEN total_cost > 50000 THEN 'medium'
            ELSE 'low'
        END,
        'total_cost', total_cost,
        'recommendations', CASE 
            WHEN total_cost > 100000 THEN 'High budget - requires detailed capacity analysis'
            WHEN total_cost > 50000 THEN 'Medium budget - monitor resource allocation'
            ELSE 'Standard budget - proceed with normal workflow'
        END
    ),
    technical_report = jsonb_build_object(
        'budget_id', id,
        'generated_at', now(),
        'status', 'pending_cto_review',
        'issues_found', 0,
        'recommendations', 'Awaiting CTO technical review'
    ),
    escalation_status = 'pending',
    updated_at = now()
WHERE cto_review_status IS NULL OR cto_review_status = 'pending';

-- Update CTO reviewer for budgets that have been reviewed
UPDATE budgeting.trn_monthly_budgets 
SET 
    cto_reviewer_id = (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1),
    technical_validation_date = CASE 
        WHEN status = 'validated' THEN now()
        ELSE NULL
    END,
    updated_at = now()
WHERE status = 'validated' AND cto_reviewer_id IS NULL;

-- =============================================================================
-- SEED 2: Update existing resource assignments with capacity scores
-- =============================================================================

-- Calculate and update capacity scores based on dedication percentage
UPDATE budgeting.trn_resource_assignments 
SET 
    capacity_score = CASE 
        WHEN dedication_percentage > 120 THEN 40  -- Overloaded
        WHEN dedication_percentage > 100 THEN 60  -- High utilization
        WHEN dedication_percentage > 80 THEN 80   -- Good utilization
        WHEN dedication_percentage > 60 THEN 90   -- Normal utilization
        ELSE 100  -- Underutilized
    END,
    technical_validation_status = CASE 
        WHEN dedication_percentage > 120 THEN 'rejected'
        WHEN dedication_percentage > 100 THEN 'validated'
        ELSE 'pending'
    END,
    cto_correction_notes = CASE 
        WHEN dedication_percentage > 120 THEN 'Overloaded - requires redistribution'
        WHEN dedication_percentage > 100 THEN 'High dedication - monitor closely'
        ELSE NULL
    END,
    updated_at = now()
WHERE capacity_score = 100.00;  -- Only update records that haven't been processed

-- Set original dedication for records that need tracking
UPDATE budgeting.trn_resource_assignments 
SET 
    original_dedication_percentage = dedication_percentage
WHERE original_dedication_percentage IS NULL;

-- =============================================================================
-- SEED 3: Update status history with CTO reviewer information
-- =============================================================================

-- Add CTO reviewer to relevant status history records
UPDATE budgeting.log_status_history 
SET 
    cto_reviewer_id = (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1)
WHERE workflow_step IN ('capacity_analysis', 'technical_validation', 'escalation') 
  AND cto_reviewer_id IS NULL;

-- =============================================================================
-- SEED 4: Add sample CTO corrections for demonstration
-- =============================================================================

-- Update some assignments to show CTO corrections
UPDATE budgeting.trn_resource_assignments 
SET 
    corrected_dedication_percentage = dedication_percentage - 20,
    cto_correction_notes = 'CTO correction: Reduced dedication to prevent overload',
    technical_validation_status = 'corrected',
    updated_at = now()
WHERE dedication_percentage > 100 
  AND corrected_dedication_percentage IS NULL
  AND id IN (
      SELECT id FROM budgeting.trn_resource_assignments 
      ORDER BY dedication_percentage DESC 
      LIMIT 2
  );

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- Verify monthly budgets updates
SELECT 'Monthly budgets updated:' as verification,
       COUNT(*) as total_budgets,
       COUNT(CASE WHEN cto_review_status IS NOT NULL THEN 1 END) as with_cto_status,
       COUNT(CASE WHEN capacity_risk_level != 'unknown' THEN 1 END) as with_risk_level
FROM budgeting.trn_monthly_budgets;

-- Verify resource assignments updates
SELECT 'Resource assignments updated:' as verification,
       COUNT(*) as total_assignments,
       COUNT(CASE WHEN capacity_score != 100.00 THEN 1 END) as with_capacity_score,
       COUNT(CASE WHEN technical_validation_status != 'pending' THEN 1 END) as with_validation_status
FROM budgeting.trn_resource_assignments;

-- Verify status history updates
SELECT 'Status history updated:' as verification,
       COUNT(*) as total_history,
       COUNT(CASE WHEN cto_reviewer_id IS NOT NULL THEN 1 END) as with_cto_reviewer
FROM budgeting.log_status_history;
