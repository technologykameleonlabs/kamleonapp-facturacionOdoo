-- =============================================================================
-- EP-010 VIEWS: STRATEGIC DASHBOARDS FOR CTO
-- =============================================================================

-- View 1: CTO Review Dashboard - Complete overview of budgets requiring attention
CREATE OR REPLACE VIEW budgeting.cto_review_dashboard AS
SELECT 
    b.id as budget_id,
    b.project_id,
    p.name as project_name,
    b.budget_month,
    b.currency,
    b.total_cost,
    b.total_margin,
    b.status as budget_status,
    b.cto_review_status,
    b.capacity_risk_level,
    b.escalation_status,
    b.technical_validation_date,
    u.name as cto_reviewer_name,
    b.capacity_analysis->>'avg_capacity_score' as avg_capacity_score,
    b.capacity_analysis->>'overload_count' as overload_count,
    b.capacity_analysis->>'underutilization_count' as underutilization_count,
    b.capacity_analysis->>'risk_assessment' as capacity_assessment,
    b.technical_report->>'technical_score' as technical_score,
    b.technical_report->>'overall_status' as technical_status,
    b.technical_report->>'issues_found' as issues_count,
    b.created_at,
    b.updated_at,
    -- Priority score for sorting (higher = more urgent)
    CASE 
        WHEN b.capacity_risk_level = 'critical' THEN 100
        WHEN b.cto_review_status = 'pending' THEN 90
        WHEN b.capacity_risk_level = 'high' THEN 80
        WHEN b.cto_review_status = 'in_review' THEN 70
        WHEN b.capacity_risk_level = 'medium' THEN 60
        ELSE 50
    END as priority_score
FROM budgeting.trn_monthly_budgets b
LEFT JOIN projects.trn_projects p ON b.project_id = p.id
LEFT JOIN base.mst_users u ON b.cto_reviewer_id = u.id
WHERE b.status IN ('validated', 'submitted_to_cto') 
   OR b.cto_review_status IN ('pending', 'in_review', 'capacity_analyzed', 'corrections_applied')
ORDER BY priority_score DESC, b.budget_month ASC, b.total_cost DESC;

COMMENT ON VIEW budgeting.cto_review_dashboard IS 'EP-010-US-001: Comprehensive dashboard for CTO budget reviews with priority scoring';

-- View 2: Capacity Risk Analysis - Detailed breakdown of capacity issues
CREATE OR REPLACE VIEW budgeting.capacity_risk_analysis AS
SELECT 
    ra.budget_id,
    b.project_id,
    p.name as project_name,
    b.budget_month,
    ra.employee_id,
    e.first_name || ' ' || e.last_name as employee_name,
    ra.dedication_percentage,
    ra.capacity_score,
    ra.technical_validation_status,
    ra.cto_correction_notes,
    ra.original_dedication_percentage,
    ra.corrected_dedication_percentage,
    -- Risk categorization
    CASE 
        WHEN ra.capacity_score > 140 THEN 'critical_overload'
        WHEN ra.capacity_score > 120 THEN 'high_overload'
        WHEN ra.capacity_score < 50 THEN 'severe_underutilization'
        WHEN ra.capacity_score < 70 THEN 'low_underutilization'
        WHEN ra.capacity_score BETWEEN 80 AND 120 THEN 'optimal'
        ELSE 'acceptable'
    END as capacity_category,
    -- Action required flag
    CASE 
        WHEN ra.capacity_score > 120 OR ra.capacity_score < 70 THEN true
        ELSE false
    END as action_required,
    -- Impact assessment
    CASE 
        WHEN ra.capacity_score > 140 THEN 'Immediate reallocation needed'
        WHEN ra.capacity_score > 120 THEN 'Monitor closely, consider adjustments'
        WHEN ra.capacity_score < 50 THEN 'Significant underutilization - reassign work'
        WHEN ra.capacity_score < 70 THEN 'Low utilization - opportunity for more work'
        ELSE 'Within acceptable capacity ranges'
    END as impact_assessment,
    ra.created_at,
    ra.updated_at
FROM budgeting.trn_resource_assignments ra
JOIN budgeting.trn_monthly_budgets b ON ra.budget_id = b.id
LEFT JOIN projects.trn_projects p ON b.project_id = p.id
LEFT JOIN masterdata.mst_employees e ON ra.employee_id = e.id
WHERE ra.capacity_score IS NOT NULL
ORDER BY 
    CASE 
        WHEN ra.capacity_score > 140 THEN 1
        WHEN ra.capacity_score > 120 THEN 2
        WHEN ra.capacity_score < 50 THEN 3
        WHEN ra.capacity_score < 70 THEN 4
        ELSE 5
    END,
    ra.capacity_score DESC;

COMMENT ON VIEW budgeting.capacity_risk_analysis IS 'EP-010-US-002: Detailed capacity risk analysis with employee-level breakdown';

-- View 3: CTO Workflow History - Complete audit trail of CTO actions
CREATE OR REPLACE VIEW budgeting.cto_workflow_history AS
SELECT 
    sh.id as history_id,
    sh.budget_id,
    b.project_id,
    p.name as project_name,
    b.budget_month,
    sh.record_type,
    sh.workflow_step,
    sh.old_status,
    sh.new_status,
    sh.change_reason,
    sh.cto_reviewer_id,
    u.name as cto_reviewer_name,
    sh.assigned_to,
    sh.due_date,
    sh.created_at as action_date,
    -- Categorize action type
    CASE 
        WHEN sh.workflow_step IN ('capacity_analysis', 'technical_validation', 'escalation') THEN 'cto_action'
        WHEN sh.workflow_step IN ('draft', 'pending_validation', 'validated') THEN 'pm_action'
        ELSE 'system_action'
    END as action_category,
    -- Time since action
    EXTRACT(EPOCH FROM (now() - sh.created_at))/3600 as hours_since_action,
    -- Is recent action (last 24 hours)
    CASE WHEN sh.created_at >= now() - INTERVAL '24 hours' THEN true ELSE false END as is_recent
FROM budgeting.log_status_history sh
LEFT JOIN budgeting.trn_monthly_budgets b ON sh.budget_id = b.id
LEFT JOIN projects.trn_projects p ON b.project_id = p.id
LEFT JOIN base.mst_users u ON sh.cto_reviewer_id = u.id
WHERE sh.workflow_step IN (
    'capacity_analysis', 'technical_validation', 'escalation',
    'draft', 'pending_validation', 'validated', 'submitted_to_cto'
)
ORDER BY sh.created_at DESC;

COMMENT ON VIEW budgeting.cto_workflow_history IS 'EP-010: Complete audit trail of CTO workflow actions and status changes';

-- View 4: Technical Validation Summary - Overview of validation results
CREATE OR REPLACE VIEW budgeting.technical_validation_summary AS
SELECT 
    b.id as budget_id,
    b.project_id,
    p.name as project_name,
    b.budget_month,
    b.cto_reviewer_id,
    u.name as cto_reviewer_name,
    b.technical_validation_date,
    b.technical_report->>'technical_score' as technical_score,
    b.technical_report->>'overall_status' as validation_status,
    b.technical_report->>'issues_found' as issues_count,
    b.technical_report->>'recommendations' as recommendations,
    -- Extract issues array for counting by severity
    (SELECT COUNT(*) FROM jsonb_array_elements(b.technical_report->'issues') 
     WHERE value->>'severity' = 'high') as high_severity_issues,
    (SELECT COUNT(*) FROM jsonb_array_elements(b.technical_report->'issues') 
     WHERE value->>'severity' = 'medium') as medium_severity_issues,
    (SELECT COUNT(*) FROM jsonb_array_elements(b.technical_report->'issues') 
     WHERE value->>'severity' = 'low') as low_severity_issues,
    -- Validation age in days
    CASE 
        WHEN b.technical_validation_date IS NOT NULL 
        THEN EXTRACT(DAY FROM (now() - b.technical_validation_date))
        ELSE NULL
    END as days_since_validation,
    b.escalation_status,
    b.created_at,
    b.updated_at
FROM budgeting.trn_monthly_budgets b
LEFT JOIN projects.trn_projects p ON b.project_id = p.id
LEFT JOIN base.mst_users u ON b.cto_reviewer_id = u.id
WHERE b.technical_validation_date IS NOT NULL
ORDER BY b.technical_validation_date DESC;

COMMENT ON VIEW budgeting.technical_validation_summary IS 'EP-010-US-004: Summary of technical validations with scoring and issue breakdown';

-- Grant permissions to authenticated users for views
GRANT SELECT ON budgeting.cto_review_dashboard TO authenticated;
GRANT SELECT ON budgeting.capacity_risk_analysis TO authenticated;
GRANT SELECT ON budgeting.cto_workflow_history TO authenticated;
GRANT SELECT ON budgeting.technical_validation_summary TO authenticated;
