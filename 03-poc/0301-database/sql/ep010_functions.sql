-- =============================================================================
-- EP-010 FUNCTIONS: INTELLIGENT SQL FOR CTO REVIEW WORKFLOW
-- =============================================================================

-- Function 1: Analyze budget capacity and update risk levels
CREATE OR REPLACE FUNCTION budgeting.analyze_budget_capacity(p_budget_id uuid)
RETURNS jsonb AS \$\$
DECLARE
    v_budget_record record;
    v_capacity_analysis jsonb := '{}';
    v_overload_count integer := 0;
    v_underutilization_count integer := 0;
    v_total_assignments integer := 0;
    v_avg_capacity_score numeric := 0;
    v_max_capacity_score numeric := 0;
BEGIN
    -- Get budget information
    SELECT * INTO v_budget_record 
    FROM budgeting.trn_monthly_budgets 
    WHERE id = p_budget_id;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Budget not found');
    END IF;
    
    -- Calculate capacity metrics from resource assignments
    SELECT 
        COUNT(*) as total_assignments,
        AVG(capacity_score) as avg_score,
        MAX(capacity_score) as max_score,
        COUNT(CASE WHEN capacity_score > 120 THEN 1 END) as overloads,
        COUNT(CASE WHEN capacity_score < 70 THEN 1 END) as underutilized
    INTO v_total_assignments, v_avg_capacity_score, v_max_capacity_score, v_overload_count, v_underutilization_count
    FROM budgeting.trn_resource_assignments 
    WHERE budget_id = p_budget_id;
    
    -- Build capacity analysis JSON
    v_capacity_analysis := jsonb_build_object(
        'budget_id', p_budget_id,
        'analysis_date', now(),
        'total_assignments', v_total_assignments,
        'avg_capacity_score', ROUND(v_avg_capacity_score, 2),
        'max_capacity_score', v_max_capacity_score,
        'overload_count', v_overload_count,
        'underutilization_count', v_underutilization_count,
        'risk_assessment', CASE 
            WHEN v_max_capacity_score > 140 THEN 'critical'
            WHEN v_max_capacity_score > 120 THEN 'high'
            WHEN v_underutilization_count > v_total_assignments * 0.3 THEN 'medium'
            WHEN v_max_capacity_score > 110 THEN 'medium'
            ELSE 'low'
        END,
        'recommendations', CASE 
            WHEN v_overload_count > 0 THEN 'Reduce dedication percentages or reassign resources'
            WHEN v_underutilization_count > v_total_assignments * 0.5 THEN 'Consider additional assignments'
            ELSE 'Capacity levels are within acceptable ranges'
        END
    );
    
    -- Update budget with capacity analysis
    UPDATE budgeting.trn_monthly_budgets 
    SET 
        capacity_analysis = v_capacity_analysis,
        capacity_risk_level = v_capacity_analysis->>'risk_assessment',
        updated_at = now()
    WHERE id = p_budget_id;
    
    -- Log capacity analysis in status history
    INSERT INTO budgeting.log_status_history (
        budget_id, record_type, workflow_step, change_reason, changed_by
    ) VALUES (
        p_budget_id, 'budget', 'capacity_analysis', 
        'Automatic capacity analysis completed - Risk: ' || (v_capacity_analysis->>'risk_assessment'), 
        (SELECT id FROM base.mst_users WHERE email LIKE '%cto%' LIMIT 1)
    );
    
    RETURN v_capacity_analysis;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.analyze_budget_capacity(uuid) IS 'EP-010-US-002: Analyze capacity risks and update budget with analysis results';

-- Function 2: Generate CTO dashboard summary
CREATE OR REPLACE FUNCTION budgeting.generate_cto_dashboard()
RETURNS jsonb AS \$\$
DECLARE
    v_dashboard jsonb;
BEGIN
    SELECT jsonb_build_object(
        'generated_at', now(),
        'total_budgets', (SELECT COUNT(*) FROM budgeting.trn_monthly_budgets),
        'pending_reviews', (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'budget_id', b.id,
                    'project_name', p.name,
                    'budget_month', b.budget_month,
                    'total_cost', b.total_cost,
                    'status', b.status,
                    'cto_status', b.cto_review_status,
                    'risk_level', b.capacity_risk_level
                )
            )
            FROM budgeting.trn_monthly_budgets b
            JOIN projects.trn_projects p ON b.project_id = p.id
            WHERE b.cto_review_status IN ('pending', 'in_review')
            ORDER BY b.budget_month, b.total_cost DESC
        ),
        'risk_summary', (
            SELECT jsonb_build_object(
                'critical', COUNT(CASE WHEN capacity_risk_level = 'critical' THEN 1 END),
                'high', COUNT(CASE WHEN capacity_risk_level = 'high' THEN 1 END),
                'medium', COUNT(CASE WHEN capacity_risk_level = 'medium' THEN 1 END),
                'low', COUNT(CASE WHEN capacity_risk_level = 'low' THEN 1 END)
            )
            FROM budgeting.trn_monthly_budgets
        ),
        'recent_activity', (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'budget_id', sh.budget_id,
                    'action', sh.workflow_step,
                    'change_reason', sh.change_reason,
                    'changed_at', sh.created_at
                )
            )
            FROM budgeting.log_status_history sh
            WHERE sh.workflow_step IN ('capacity_analysis', 'technical_validation', 'escalation')
            AND sh.created_at >= CURRENT_DATE - INTERVAL '7 days'
            ORDER BY sh.created_at DESC
            LIMIT 10
        )
    ) INTO v_dashboard;
    
    RETURN v_dashboard;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.generate_cto_dashboard() IS 'EP-010-US-001: Generate comprehensive CTO dashboard with budget summaries and risk analysis';

-- Function 3: Apply CTO corrections to resource assignments
CREATE OR REPLACE FUNCTION budgeting.apply_cto_corrections(p_budget_id uuid, p_corrections jsonb)
RETURNS jsonb AS \$\$
DECLARE
    v_correction record;
    v_result jsonb := '[]';
    v_cto_user_id uuid;
BEGIN
    -- Get CTO user (first user with CTO in email or role)
    SELECT id INTO v_cto_user_id 
    FROM base.mst_users 
    WHERE email LIKE '%cto%' OR email LIKE '%chief%' OR email LIKE '%technical%' 
    LIMIT 1;
    
    -- Apply corrections from JSON array
    FOR v_correction IN SELECT * FROM jsonb_array_elements(p_corrections)
    LOOP
        -- Update resource assignment with corrections
        UPDATE budgeting.trn_resource_assignments 
        SET 
            corrected_dedication_percentage = (v_correction.value->>'corrected_percentage')::numeric,
            cto_correction_notes = v_correction.value->>'notes',
            technical_validation_status = 'corrected',
            updated_at = now(),
            updated_by = v_cto_user_id
        WHERE id = (v_correction.value->>'assignment_id')::uuid;
        
        -- Store original value if not already stored
        UPDATE budgeting.trn_resource_assignments 
        SET original_dedication_percentage = dedication_percentage
        WHERE id = (v_correction.value->>'assignment_id')::uuid 
        AND original_dedication_percentage IS NULL;
        
        -- Add to result
        v_result := v_result || jsonb_build_object(
            'assignment_id', v_correction.value->>'assignment_id',
            'original_percentage', (v_correction.value->>'original_percentage')::numeric,
            'corrected_percentage', (v_correction.value->>'corrected_percentage')::numeric,
            'status', 'applied'
        );
    END LOOP;
    
    -- Update budget status
    UPDATE budgeting.trn_monthly_budgets 
    SET 
        cto_review_status = 'corrections_applied',
        updated_at = now()
    WHERE id = p_budget_id;
    
    -- Log corrections in status history
    INSERT INTO budgeting.log_status_history (
        budget_id, record_type, workflow_step, change_reason, changed_by
    ) VALUES (
        p_budget_id, 'budget', 'corrections_applied', 
        'CTO corrections applied to ' || jsonb_array_length(p_corrections) || ' assignments', 
        v_cto_user_id
    );
    
    RETURN jsonb_build_object(
        'status', 'success',
        'corrections_applied', jsonb_array_length(p_corrections),
        'details', v_result
    );
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.apply_cto_corrections(uuid, jsonb) IS 'EP-010-US-003: Apply CTO corrections to resource assignments with full audit trail';

-- Function 4: Validate technical feasibility
CREATE OR REPLACE FUNCTION budgeting.validate_technical_feasibility(p_budget_id uuid)
RETURNS jsonb AS \$\$
DECLARE
    v_budget_record record;
    v_validation_result jsonb;
    v_cto_user_id uuid;
    v_technical_score integer := 100;
    v_issues jsonb := '[]';
BEGIN
    -- Get budget information
    SELECT * INTO v_budget_record 
    FROM budgeting.trn_monthly_budgets 
    WHERE id = p_budget_id;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Budget not found');
    END IF;
    
    -- Get CTO user
    SELECT id INTO v_cto_user_id 
    FROM base.mst_users 
    WHERE email LIKE '%cto%' OR email LIKE '%chief%' OR email LIKE '%technical%' 
    LIMIT 1;
    
    -- Check for technical issues
    -- Issue 1: High capacity risk
    IF v_budget_record.capacity_risk_level IN ('high', 'critical') THEN
        v_technical_score := v_technical_score - 30;
        v_issues := v_issues || jsonb_build_object(
            'type', 'capacity_risk',
            'severity', 'high',
            'description', 'High capacity utilization detected - potential resource bottleneck'
        );
    END IF;
    
    -- Issue 2: Assignments without validation
    IF EXISTS (
        SELECT 1 FROM budgeting.trn_resource_assignments 
        WHERE budget_id = p_budget_id 
        AND technical_validation_status = 'pending'
    ) THEN
        v_technical_score := v_technical_score - 20;
        v_issues := v_issues || jsonb_build_object(
            'type', 'validation_pending',
            'severity', 'medium',
            'description', 'Some assignments still pending technical validation'
        );
    END IF;
    
    -- Build validation report
    v_validation_result := jsonb_build_object(
        'budget_id', p_budget_id,
        'validation_date', now(),
        'technical_score', v_technical_score,
        'overall_status', CASE 
            WHEN v_technical_score >= 80 THEN 'approved'
            WHEN v_technical_score >= 60 THEN 'conditional'
            ELSE 'rejected'
        END,
        'issues_found', jsonb_array_length(v_issues),
        'issues', v_issues,
        'recommendations', CASE 
            WHEN v_technical_score >= 80 THEN 'Technical validation passed - ready for escalation'
            WHEN v_technical_score >= 60 THEN 'Address identified issues before escalation'
            ELSE 'Major technical concerns - requires revision'
        END
    );
    
    -- Update budget with validation results
    UPDATE budgeting.trn_monthly_budgets 
    SET 
        technical_report = v_validation_result,
        cto_review_status = CASE 
            WHEN v_technical_score >= 80 THEN 'technically_validated'
            ELSE 'corrections_applied'
        END,
        technical_validation_date = now(),
        cto_reviewer_id = v_cto_user_id,
        updated_at = now()
    WHERE id = p_budget_id;
    
    -- Log validation in status history
    INSERT INTO budgeting.log_status_history (
        budget_id, record_type, workflow_step, change_reason, changed_by
    ) VALUES (
        p_budget_id, 'budget', 'technical_validation', 
        'Technical validation completed - Score: ' || v_technical_score || '/100', 
        v_cto_user_id
    );
    
    RETURN v_validation_result;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.validate_technical_feasibility(uuid) IS 'EP-010-US-004: Complete technical validation with scoring and recommendations';

-- Function 5: Escalate to executive approval
CREATE OR REPLACE FUNCTION budgeting.escalate_to_executive_approval(p_budget_id uuid)
RETURNS jsonb AS \$\$
DECLARE
    v_budget_record record;
    v_cto_user_id uuid;
    v_result jsonb;
BEGIN
    -- Get budget information
    SELECT * INTO v_budget_record 
    FROM budgeting.trn_monthly_budgets 
    WHERE id = p_budget_id;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Budget not found');
    END IF;
    
    -- Check if budget is ready for escalation
    IF v_budget_record.cto_review_status != 'technically_validated' THEN
        RETURN jsonb_build_object(
            'error', 'Budget not ready for escalation',
            'current_status', v_budget_record.cto_review_status,
            'required_status', 'technically_validated'
        );
    END IF;
    
    -- Get CTO user
    SELECT id INTO v_cto_user_id 
    FROM base.mst_users 
    WHERE email LIKE '%cto%' OR email LIKE '%chief%' OR email LIKE '%technical%' 
    LIMIT 1;
    
    -- Update budget for escalation
    UPDATE budgeting.trn_monthly_budgets 
    SET 
        cto_review_status = 'escalated_to_executive',
        escalation_status = 'escalated',
        updated_at = now()
    WHERE id = p_budget_id;
    
    -- Log escalation in status history
    INSERT INTO budgeting.log_status_history (
        budget_id, record_type, workflow_step, change_reason, changed_by
    ) VALUES (
        p_budget_id, 'budget', 'escalation', 
        'Budget escalated to executive approval after technical validation', 
        v_cto_user_id
    );
    
    v_result := jsonb_build_object(
        'status', 'escalated',
        'budget_id', p_budget_id,
        'escalation_date', now(),
        'escalated_by', v_cto_user_id,
        'next_step', 'Awaiting executive approval',
        'estimated_review_time', '2-4 business days'
    );
    
    RETURN v_result;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.escalate_to_executive_approval(uuid) IS 'EP-010-US-005: Escalate technically validated budget to executive approval';

-- Function 6: Get capacity risk report
CREATE OR REPLACE FUNCTION budgeting.get_capacity_risk_report(p_budget_id uuid)
RETURNS jsonb AS \$\$
DECLARE
    v_report jsonb;
BEGIN
    SELECT jsonb_build_object(
        'budget_id', p_budget_id,
        'generated_at', now(),
        'capacity_summary', (
            SELECT jsonb_build_object(
                'total_assignments', COUNT(*),
                'avg_capacity_score', ROUND(AVG(capacity_score), 2),
                'max_capacity_score', MAX(capacity_score),
                'min_capacity_score', MIN(capacity_score),
                'overload_count', COUNT(CASE WHEN capacity_score > 120 THEN 1 END),
                'underutilization_count', COUNT(CASE WHEN capacity_score < 70 THEN 1 END),
                'optimal_count', COUNT(CASE WHEN capacity_score BETWEEN 80 AND 120 THEN 1 END)
            )
            FROM budgeting.trn_resource_assignments 
            WHERE budget_id = p_budget_id
        ),
        'risky_assignments', (
            SELECT jsonb_agg(
                jsonb_build_object(
                    'assignment_id', ra.id,
                    'employee_id', ra.employee_id,
                    'capacity_score', ra.capacity_score,
                    'dedication_percentage', ra.dedication_percentage,
                    'risk_level', CASE 
                        WHEN ra.capacity_score > 140 THEN 'critical'
                        WHEN ra.capacity_score > 120 THEN 'high'
                        WHEN ra.capacity_score < 70 THEN 'underutilized'
                        ELSE 'normal'
                    END
                )
            )
            FROM budgeting.trn_resource_assignments ra
            WHERE ra.budget_id = p_budget_id 
            AND (ra.capacity_score > 120 OR ra.capacity_score < 70)
        ),
        'recommendations', (
            SELECT jsonb_agg(
                CASE 
                    WHEN capacity_score > 140 THEN 'Critical overload - immediate reallocation required'
                    WHEN capacity_score > 120 THEN 'High utilization - consider reducing dedication'
                    WHEN capacity_score < 50 THEN 'Severe underutilization - consider additional assignments'
                    WHEN capacity_score < 70 THEN 'Low utilization - opportunity for optimization'
                    ELSE 'Within acceptable ranges'
                END
            )
            FROM budgeting.trn_resource_assignments 
            WHERE budget_id = p_budget_id
            AND (capacity_score > 120 OR capacity_score < 70)
        )
    ) INTO v_report;
    
    RETURN v_report;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.get_capacity_risk_report(uuid) IS 'EP-010-US-002: Generate detailed capacity risk report for CTO review';
