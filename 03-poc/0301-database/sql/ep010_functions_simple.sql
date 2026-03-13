-- =============================================================================
-- EP-010 FUNCTIONS: SIMPLIFIED VERSIONS FOR CTO WORKFLOW
-- =============================================================================

-- Function 1: Analyze budget capacity (simplified)
CREATE OR REPLACE FUNCTION budgeting.analyze_budget_capacity(p_budget_id uuid)
RETURNS text AS \$\$
DECLARE
    v_overload_count integer := 0;
    v_total_assignments integer := 0;
BEGIN
    -- Simple capacity analysis
    SELECT 
        COUNT(*),
        COUNT(CASE WHEN capacity_score > 120 THEN 1 END)
    INTO v_total_assignments, v_overload_count
    FROM budgeting.trn_resource_assignments 
    WHERE budget_id = p_budget_id;
    
    -- Update budget with simple analysis
    UPDATE budgeting.trn_monthly_budgets 
    SET 
        capacity_risk_level = CASE 
            WHEN v_overload_count > 0 THEN 'high'
            WHEN v_total_assignments > 0 THEN 'medium'
            ELSE 'low'
        END,
        updated_at = now()
    WHERE id = p_budget_id;
    
    RETURN 'Capacity analysis completed for budget ' || p_budget_id::text;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 2: Generate CTO dashboard (simplified)
CREATE OR REPLACE FUNCTION budgeting.generate_cto_dashboard()
RETURNS text AS \$\$
DECLARE
    v_pending_count integer := 0;
BEGIN
    SELECT COUNT(*) INTO v_pending_count
    FROM budgeting.trn_monthly_budgets
    WHERE cto_review_status IN ('pending', 'in_review');
    
    RETURN 'CTO Dashboard: ' || v_pending_count || ' budgets pending review';
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 3: Apply CTO corrections (simplified)
CREATE OR REPLACE FUNCTION budgeting.apply_cto_corrections(p_budget_id uuid, p_assignment_id uuid, p_new_percentage numeric)
RETURNS text AS \$\$
BEGIN
    -- Update resource assignment
    UPDATE budgeting.trn_resource_assignments 
    SET 
        corrected_dedication_percentage = p_new_percentage,
        technical_validation_status = 'corrected',
        updated_at = now()
    WHERE id = p_assignment_id;
    
    -- Update budget status
    UPDATE budgeting.trn_monthly_budgets 
    SET 
        cto_review_status = 'corrections_applied',
        updated_at = now()
    WHERE id = p_budget_id;
    
    RETURN 'Correction applied successfully';
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 4: Validate technical feasibility (simplified)
CREATE OR REPLACE FUNCTION budgeting.validate_technical_feasibility(p_budget_id uuid)
RETURNS text AS \$\$
DECLARE
    v_issues_count integer := 0;
BEGIN
    -- Count potential issues
    SELECT COUNT(*) INTO v_issues_count
    FROM budgeting.trn_resource_assignments 
    WHERE budget_id = p_budget_id 
    AND (capacity_score > 120 OR technical_validation_status = 'pending');
    
    -- Update budget with validation
    UPDATE budgeting.trn_monthly_budgets 
    SET 
        cto_review_status = CASE 
            WHEN v_issues_count = 0 THEN 'technically_validated'
            ELSE 'corrections_applied'
        END,
        technical_validation_date = now(),
        updated_at = now()
    WHERE id = p_budget_id;
    
    RETURN 'Technical validation completed - ' || v_issues_count || ' issues found';
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 5: Escalate to executive approval (simplified)
CREATE OR REPLACE FUNCTION budgeting.escalate_to_executive_approval(p_budget_id uuid)
RETURNS text AS \$\$
BEGIN
    -- Check if ready for escalation
    IF NOT EXISTS (
        SELECT 1 FROM budgeting.trn_monthly_budgets 
        WHERE id = p_budget_id 
        AND cto_review_status = 'technically_validated'
    ) THEN
        RETURN 'Budget not ready for escalation - requires technical validation';
    END IF;
    
    -- Update for escalation
    UPDATE budgeting.trn_monthly_budgets 
    SET 
        cto_review_status = 'escalated_to_executive',
        escalation_status = 'escalated',
        updated_at = now()
    WHERE id = p_budget_id;
    
    RETURN 'Budget escalated to executive approval successfully';
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 6: Get capacity risk report (simplified)
CREATE OR REPLACE FUNCTION budgeting.get_capacity_risk_report(p_budget_id uuid)
RETURNS text AS \$\$
DECLARE
    v_report text := '';
    v_overload_count integer := 0;
    v_total_count integer := 0;
BEGIN
    SELECT 
        COUNT(*),
        COUNT(CASE WHEN capacity_score > 120 THEN 1 END)
    INTO v_total_count, v_overload_count
    FROM budgeting.trn_resource_assignments 
    WHERE budget_id = p_budget_id;
    
    v_report := 'Capacity Report for Budget ' || p_budget_id::text || '\n';
    v_report := v_report || 'Total assignments: ' || v_total_count || '\n';
    v_report := v_report || 'Overload risks: ' || v_overload_count || '\n';
    v_report := v_report || 'Risk level: ' || CASE 
        WHEN v_overload_count > 0 THEN 'HIGH'
        WHEN v_total_count > 0 THEN 'MEDIUM'
        ELSE 'LOW'
    END;
    
    RETURN v_report;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;
