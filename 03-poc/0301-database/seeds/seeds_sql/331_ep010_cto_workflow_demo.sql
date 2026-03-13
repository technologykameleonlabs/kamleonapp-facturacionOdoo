-- =============================================================================
-- SEEDS: EP-010 CTO Workflow Demonstration Data
-- =============================================================================
-- Purpose: Create demonstration data showing CTO workflow in action
-- Dependencies: EP-009 tables + EP-010 extensions populated
-- Tables affected: budgeting.trn_monthly_budgets, budgeting.trn_resource_assignments, budgeting.log_status_history
-- =============================================================================

-- =============================================================================
-- SEED 1: Create sample CTO workflow progression
-- =============================================================================

-- Mark one budget as being reviewed by CTO
UPDATE budgeting.trn_monthly_budgets 
SET 
    cto_review_status = 'in_review',
    cto_reviewer_id = (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1),
    capacity_analysis = jsonb_build_object(
        'budget_id', id,
        'analysis_date', now(),
        'total_assignments', 3,
        'avg_capacity_score', 85.5,
        'max_capacity_score', 110,
        'overload_count', 1,
        'underutilization_count', 0,
        'risk_assessment', 'medium',
        'recommendations', 'One assignment shows high utilization - consider adjustments'
    ),
    updated_at = now()
WHERE id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1);

-- Mark another budget as technically validated
UPDATE budgeting.trn_monthly_budgets 
SET 
    cto_review_status = 'technically_validated',
    cto_reviewer_id = (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1),
    technical_validation_date = now(),
    technical_report = jsonb_build_object(
        'budget_id', id,
        'validation_date', now(),
        'technical_score', 90,
        'overall_status', 'approved',
        'issues_found', 1,
        'issues', jsonb_build_array(
            jsonb_build_object(
                'type', 'capacity_warning',
                'severity', 'low',
                'description', 'One resource at 95% capacity - acceptable for short term'
            )
        ),
        'recommendations', 'Technical validation passed - budget ready for escalation',
        'validated_by', 'CTO'
    ),
    escalation_status = 'escalated',
    updated_at = now()
WHERE id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1 OFFSET 1);

-- =============================================================================
-- SEED 2: Create sample capacity analysis details
-- =============================================================================

-- Update assignments with detailed capacity analysis
UPDATE budgeting.trn_resource_assignments 
SET 
    capacity_score = 110,
    technical_validation_status = 'validated',
    cto_correction_notes = 'High utilization but within acceptable range for senior developer',
    updated_at = now()
WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1)
  AND id = (SELECT id FROM budgeting.trn_resource_assignments WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1) ORDER BY dedication_percentage DESC LIMIT 1);

-- Update another assignment to show underutilization
UPDATE budgeting.trn_resource_assignments 
SET 
    capacity_score = 45,
    technical_validation_status = 'validated',
    cto_correction_notes = 'Underutilized - consider additional assignments',
    updated_at = now()
WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1)
  AND id = (SELECT id FROM budgeting.trn_resource_assignments WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1) ORDER BY dedication_percentage ASC LIMIT 1);

-- =============================================================================
-- SEED 3: Add workflow history entries for CTO actions
-- =============================================================================

-- Add capacity analysis entry
INSERT INTO budgeting.log_status_history (
    id, budget_id, record_type, workflow_step, change_reason, changed_by, cto_reviewer_id
) VALUES (
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1),
    'budget', 'capacity_analysis',
    'Capacity analysis completed - 1 high utilization issue identified',
    (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1)
) ON CONFLICT DO NOTHING;

-- Add technical validation entry
INSERT INTO budgeting.log_status_history (
    id, budget_id, record_type, workflow_step, change_reason, changed_by, cto_reviewer_id
) VALUES (
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1 OFFSET 1),
    'budget', 'technical_validation',
    'Technical validation completed - Score: 90/100, approved for escalation',
    (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1)
) ON CONFLICT DO NOTHING;

-- Add escalation entry
INSERT INTO budgeting.log_status_history (
    id, budget_id, record_type, workflow_step, change_reason, changed_by, cto_reviewer_id
) VALUES (
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY created_at ASC LIMIT 1 OFFSET 1),
    'budget', 'escalation',
    'Budget escalated to executive approval after technical validation',
    (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1)
) ON CONFLICT DO NOTHING;

-- =============================================================================
-- SEED 4: Add assignment-level corrections
-- =============================================================================

-- Create a corrected assignment example
UPDATE budgeting.trn_resource_assignments 
SET 
    original_dedication_percentage = dedication_percentage,
    corrected_dedication_percentage = dedication_percentage - 15,
    cto_correction_notes = 'CTO correction: Reduced from ' || dedication_percentage || '% to ' || (dedication_percentage - 15) || '% to prevent burnout',
    technical_validation_status = 'corrected',
    updated_at = now()
WHERE capacity_score > 100 
  AND corrected_dedication_percentage IS NULL
  AND id = (SELECT id FROM budgeting.trn_resource_assignments WHERE capacity_score > 100 ORDER BY capacity_score DESC LIMIT 1);

-- Add correction history entry
INSERT INTO budgeting.log_status_history (
    id, budget_id, assignment_id, record_type, workflow_step, change_reason, changed_by, cto_reviewer_id
) VALUES (
    gen_random_uuid(),
    (SELECT budget_id FROM budgeting.trn_resource_assignments WHERE corrected_dedication_percentage IS NOT NULL ORDER BY updated_at DESC LIMIT 1),
    (SELECT id FROM budgeting.trn_resource_assignments WHERE corrected_dedication_percentage IS NOT NULL ORDER BY updated_at DESC LIMIT 1),
    'assignment', 'corrections_applied',
    'Assignment dedication corrected from ' || (SELECT original_dedication_percentage FROM budgeting.trn_resource_assignments WHERE corrected_dedication_percentage IS NOT NULL ORDER BY updated_at DESC LIMIT 1) || '% to ' || (SELECT corrected_dedication_percentage FROM budgeting.trn_resource_assignments WHERE corrected_dedication_percentage IS NOT NULL ORDER BY updated_at DESC LIMIT 1) || '%',
    (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1),
    (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' OR email LIKE '%chief%' LIMIT 1)
) ON CONFLICT DO NOTHING;

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- Show CTO workflow status summary
SELECT 'CTO Workflow Status Summary:' as report,
       COUNT(*) as total_budgets,
       COUNT(CASE WHEN cto_review_status = 'pending' THEN 1 END) as pending_review,
       COUNT(CASE WHEN cto_review_status = 'in_review' THEN 1 END) as in_review,
       COUNT(CASE WHEN cto_review_status = 'technically_validated' THEN 1 END) as validated,
       COUNT(CASE WHEN escalation_status = 'escalated' THEN 1 END) as escalated
FROM budgeting.trn_monthly_budgets;

-- Show capacity analysis summary
SELECT 'Capacity Analysis Summary:' as report,
       COUNT(*) as total_assignments,
       COUNT(CASE WHEN capacity_score > 120 THEN 1 END) as overloaded,
       COUNT(CASE WHEN capacity_score BETWEEN 80 AND 120 THEN 1 END) as optimal,
       COUNT(CASE WHEN capacity_score < 70 THEN 1 END) as underutilized,
       ROUND(AVG(capacity_score), 1) as avg_capacity_score
FROM budgeting.trn_resource_assignments;

-- Show corrections applied
SELECT 'Corrections Applied:' as report,
       COUNT(CASE WHEN corrected_dedication_percentage IS NOT NULL THEN 1 END) as assignments_corrected,
       COUNT(CASE WHEN technical_validation_status = 'corrected' THEN 1 END) as validation_corrections
FROM budgeting.trn_resource_assignments;
