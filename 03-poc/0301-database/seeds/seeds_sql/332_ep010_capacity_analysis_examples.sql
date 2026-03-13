-- =============================================================================
-- SEEDS: EP-010 CTO Capacity Analysis Examples
-- =============================================================================
-- Purpose: Create detailed examples of capacity analysis and risk assessment
-- Dependencies: EP-009 tables + EP-010 extensions populated
-- Tables affected: budgeting.trn_resource_assignments, budgeting.trn_monthly_budgets
-- =============================================================================

-- =============================================================================
-- SEED 1: Detailed capacity analysis examples
-- =============================================================================

-- Example 1: High-risk budget with multiple capacity issues
UPDATE budgeting.trn_monthly_budgets 
SET 
    capacity_risk_level = 'high',
    capacity_analysis = jsonb_build_object(
        'budget_id', id,
        'analysis_date', now(),
        'risk_level', 'high',
        'total_assignments', 4,
        'avg_capacity_score', 92.5,
        'max_capacity_score', 135,
        'min_capacity_score', 45,
        'overload_count', 2,
        'underutilization_count', 1,
        'critical_issues', jsonb_build_array(
            'Senior Developer overloaded (135% capacity)',
            'QA Engineer overloaded (125% capacity)',
            'Junior Developer underutilized (45% capacity)'
        ),
        'recommendations', jsonb_build_array(
            'Redistribute work from overloaded developers',
            'Consider hiring additional QA resources',
            'Increase utilization of underutilized junior developer',
            'Review project timeline vs resource availability'
        ),
        'estimated_impact', 'High risk of delays and quality issues',
        'suggested_actions', jsonb_build_array(
            'Immediate: Reduce Senior Developer dedication by 20%',
            'Short-term: Hire additional QA resource',
            'Medium-term: Review project scope and timeline'
        )
    ),
    updated_at = now()
WHERE id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1);

-- Example 2: Medium-risk budget with balanced capacity
UPDATE budgeting.trn_monthly_budgets 
SET 
    capacity_risk_level = 'medium',
    capacity_analysis = jsonb_build_object(
        'budget_id', id,
        'analysis_date', now(),
        'risk_level', 'medium',
        'total_assignments', 3,
        'avg_capacity_score', 78.3,
        'max_capacity_score', 95,
        'min_capacity_score', 65,
        'overload_count', 0,
        'underutilization_count', 1,
        'capacity_distribution', jsonb_build_object(
            'optimal_range', '80-100%',
            'assignments_in_range', 2,
            'assignments_below_range', 1,
            'assignments_above_range', 0
        ),
        'recommendations', jsonb_build_array(
            'Monitor resource utilization closely',
            'Consider additional assignments for underutilized resources',
            'Good overall capacity balance maintained'
        ),
        'estimated_impact', 'Low to medium risk - manageable with monitoring',
        'suggested_actions', jsonb_build_array(
            'Monitor: Track capacity scores weekly',
            'Optimize: Increase utilization of underutilized resource by 15%'
        )
    ),
    updated_at = now()
WHERE id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost ASC LIMIT 1 OFFSET 1);

-- Example 3: Low-risk budget with optimal capacity
UPDATE budgeting.trn_monthly_budgets 
SET 
    capacity_risk_level = 'low',
    capacity_analysis = jsonb_build_object(
        'budget_id', id,
        'analysis_date', now(),
        'risk_level', 'low',
        'total_assignments', 2,
        'avg_capacity_score', 85.0,
        'max_capacity_score', 90,
        'min_capacity_score', 80,
        'overload_count', 0,
        'underutilization_count', 0,
        'capacity_distribution', jsonb_build_object(
            'optimal_range', '80-100%',
            'assignments_in_range', 2,
            'assignments_below_range', 0,
            'assignments_above_range', 0
        ),
        'recommendations', jsonb_build_array(
            'Excellent capacity utilization',
            'Resources well-balanced across project',
            'Continue monitoring for optimal performance'
        ),
        'estimated_impact', 'Very low risk - optimal resource utilization',
        'performance_indicators', jsonb_build_object(
            'efficiency_score', 95,
            'balance_score', 98,
            'optimization_score', 92
        )
    ),
    updated_at = now()
WHERE id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost ASC LIMIT 1 OFFSET 2);

-- =============================================================================
-- SEED 2: Update resource assignments with detailed capacity scores
-- =============================================================================

-- Update assignments for high-risk budget
UPDATE budgeting.trn_resource_assignments 
SET 
    capacity_score = 135,
    technical_validation_status = 'validated',
    cto_correction_notes = 'Critical overload - immediate action required'
WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1)
  AND id = (SELECT id FROM budgeting.trn_resource_assignments WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1) ORDER BY dedication_percentage DESC LIMIT 1);

UPDATE budgeting.trn_resource_assignments 
SET 
    capacity_score = 125,
    technical_validation_status = 'validated',
    cto_correction_notes = 'High utilization - monitor closely'
WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1)
  AND id = (SELECT id FROM budgeting.trn_resource_assignments WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1) ORDER BY dedication_percentage DESC LIMIT 1 OFFSET 1);

UPDATE budgeting.trn_resource_assignments 
SET 
    capacity_score = 45,
    technical_validation_status = 'validated',
    cto_correction_notes = 'Underutilized - consider additional assignments'
WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1)
  AND id = (SELECT id FROM budgeting.trn_resource_assignments WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1) ORDER BY dedication_percentage ASC LIMIT 1);

UPDATE budgeting.trn_resource_assignments 
SET 
    capacity_score = 85,
    technical_validation_status = 'validated',
    cto_correction_notes = 'Good utilization - maintain current level'
WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1)
  AND capacity_score = 100.00
  AND id NOT IN (
      SELECT id FROM budgeting.trn_resource_assignments 
      WHERE budget_id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1)
      AND capacity_score IN (135, 125, 45)
  );

-- =============================================================================
-- SEED 3: Add detailed technical reports
-- =============================================================================

-- Technical report for high-risk budget
UPDATE budgeting.trn_monthly_budgets 
SET 
    technical_report = jsonb_build_object(
        'budget_id', id,
        'validation_date', now(),
        'technical_score', 65,
        'overall_status', 'conditional',
        'issues_found', 3,
        'issues', jsonb_build_array(
            jsonb_build_object(
                'type', 'capacity_overload',
                'severity', 'high',
                'description', 'Two resources overloaded (>120% capacity)',
                'impact', 'High risk of delays and quality degradation',
                'recommendation', 'Immediate redistribution of workload'
            ),
            jsonb_build_object(
                'type', 'resource_underutilization',
                'severity', 'medium',
                'description', 'One resource underutilized (<50% capacity)',
                'impact', 'Inefficient resource allocation',
                'recommendation', 'Increase workload or reassign resource'
            ),
            jsonb_build_object(
                'type', 'capacity_imbalance',
                'severity', 'medium',
                'description', 'Significant variance in capacity utilization across team',
                'impact', 'Potential bottlenecks and inefficiencies',
                'recommendation', 'Balance workload distribution'
            )
        ),
        'technical_assessment', jsonb_build_object(
            'strengths', jsonb_build_array('Experienced team', 'Clear project scope'),
            'weaknesses', jsonb_build_array('Resource overload', 'Capacity imbalance'),
            'opportunities', jsonb_build_array('Workload optimization', 'Resource rebalancing'),
            'threats', jsonb_build_array('Project delays', 'Quality issues')
        ),
        'recommendations', jsonb_build_array(
            'Immediate: Reduce Senior Developer dedication by 25%',
            'Short-term: Increase Junior Developer utilization by 30%',
            'Medium-term: Review project timeline and resource allocation',
            'Monitor: Weekly capacity score tracking'
        ),
        'approval_conditions', jsonb_build_array(
            'Implement workload redistribution within 1 week',
            'Increase monitoring frequency to weekly',
            'Provide capacity adjustment plan'
        ),
        'validated_by', 'CTO',
        'review_period', 'Q1 2025'
    ),
    updated_at = now()
WHERE id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost DESC LIMIT 1);

-- Technical report for medium-risk budget
UPDATE budgeting.trn_monthly_budgets 
SET 
    technical_report = jsonb_build_object(
        'budget_id', id,
        'validation_date', now(),
        'technical_score', 82,
        'overall_status', 'approved',
        'issues_found', 1,
        'issues', jsonb_build_array(
            jsonb_build_object(
                'type', 'capacity_underutilization',
                'severity', 'low',
                'description', 'One resource slightly underutilized (65% capacity)',
                'impact', 'Minor inefficiency',
                'recommendation', 'Monitor and optimize as needed'
            )
        ),
        'technical_assessment', jsonb_build_object(
            'strengths', jsonb_build_array('Balanced team composition', 'Good capacity distribution'),
            'weaknesses', jsonb_build_array('Minor underutilization'),
            'opportunities', jsonb_build_array('Further optimization possible'),
            'threats', jsonb_build_array('None identified')
        ),
        'recommendations', jsonb_build_array(
            'Monitor resource utilization weekly',
            'Consider additional assignments for underutilized resource',
            'Maintain current workload balance'
        ),
        'validated_by', 'CTO',
        'review_period', 'Q1 2025'
    ),
    updated_at = now()
WHERE id = (SELECT id FROM budgeting.trn_monthly_budgets ORDER BY total_cost ASC LIMIT 1 OFFSET 1);

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- Show detailed capacity analysis
SELECT 'Detailed Capacity Analysis:' as report,
       COUNT(CASE WHEN capacity_risk_level = 'high' THEN 1 END) as high_risk_budgets,
       COUNT(CASE WHEN capacity_risk_level = 'medium' THEN 1 END) as medium_risk_budgets,
       COUNT(CASE WHEN capacity_risk_level = 'low' THEN 1 END) as low_risk_budgets,
       ROUND(AVG((capacity_analysis->>'avg_capacity_score')::numeric), 2) as overall_avg_capacity
FROM budgeting.trn_monthly_budgets
WHERE capacity_analysis IS NOT NULL;

-- Show technical validation summary
SELECT 'Technical Validation Summary:' as report,
       COUNT(CASE WHEN (technical_report->>'overall_status') = 'approved' THEN 1 END) as approved_budgets,
       COUNT(CASE WHEN (technical_report->>'overall_status') = 'conditional' THEN 1 END) as conditional_budgets,
       ROUND(AVG((technical_report->>'technical_score')::numeric), 2) as avg_technical_score,
       SUM((technical_report->>'issues_found')::integer) as total_issues_found
FROM budgeting.trn_monthly_budgets
WHERE technical_report IS NOT NULL;

-- Show assignment corrections summary
SELECT 'Assignment Corrections Summary:' as report,
       COUNT(CASE WHEN corrected_dedication_percentage IS NOT NULL THEN 1 END) as assignments_corrected,
       ROUND(AVG(CASE WHEN corrected_dedication_percentage IS NOT NULL THEN 
           original_dedication_percentage - corrected_dedication_percentage END), 2) as avg_reduction_percentage
FROM budgeting.trn_resource_assignments
WHERE corrected_dedication_percentage IS NOT NULL;
