-- EP-009: Planificación Presupuestaria por PM
-- Date: 2025-09-16
-- Description: Sistema integral de planificación mensual de presupuestos por Project Manager
-- Tables: 6 new tables, extensions to existing tables, 6 functions

-- ===========================================
-- CREATE SCHEMA: budgeting
-- ===========================================

CREATE SCHEMA IF NOT EXISTS budgeting;
COMMENT ON SCHEMA budgeting IS 'EP-009: Budget planning and management by Project Managers';

-- Grant permissions
GRANT USAGE ON SCHEMA budgeting TO authenticated;
GRANT CREATE ON SCHEMA budgeting TO service_role;

-- ===========================================
-- TABLE 1: monthly_budgets
-- ===========================================

CREATE TABLE IF NOT EXISTS budgeting.monthly_budgets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id uuid NOT NULL REFERENCES projects.trn_projects(id),
    budget_month date NOT NULL,
    currency text DEFAULT 'EUR',
    status text DEFAULT 'draft' CHECK (status IN ('draft', 'pending_validation', 'validated', 'submitted_to_cto', 'approved', 'rejected')),
    total_cost numeric(12,2) DEFAULT 0,
    total_margin numeric(12,2) DEFAULT 0,
    target_margin numeric(5,2), -- Target margin for this budget
    capacity_snapshot jsonb, -- Snapshot of capacity at budget creation
    validation_notes text,
    submitted_to_cto_at timestamptz,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL REFERENCES base.mst_users(id),
    updated_by uuid NOT NULL REFERENCES base.mst_users(id)
);

COMMENT ON TABLE budgeting.monthly_budgets IS 'EP-009: Monthly budgets by project';
COMMENT ON COLUMN budgeting.monthly_budgets.capacity_snapshot IS 'EP-009-US-001: Snapshot of resource capacity at budget creation';
COMMENT ON COLUMN budgeting.monthly_budgets.target_margin IS 'EP-009-US-004: Target margin for profitability comparison';

-- Indexes for monthly_budgets
CREATE INDEX IF NOT EXISTS idx_monthly_budgets_project_month ON budgeting.monthly_budgets(project_id, budget_month);
CREATE INDEX IF NOT EXISTS idx_monthly_budgets_status_date ON budgeting.monthly_budgets(status, created_at);
CREATE INDEX IF NOT EXISTS idx_monthly_budgets_currency ON budgeting.monthly_budgets(currency);

-- ===========================================
-- TABLE 2: resource_assignments
-- ===========================================

CREATE TABLE IF NOT EXISTS budgeting.resource_assignments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id uuid NOT NULL REFERENCES budgeting.monthly_budgets(id) ON DELETE CASCADE,
    employee_id uuid NOT NULL REFERENCES masterdata.mst_employees(id),
    dedication_percentage numeric(5,2) NOT NULL CHECK (dedication_percentage > 0 AND dedication_percentage <= 100),
    monthly_cost numeric(12,2),
    status text DEFAULT 'draft' CHECK (status IN ('draft', 'pending_validation', 'validated', 'rejected')),
    validation_notes text,
    skills_validated boolean DEFAULT false,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL REFERENCES base.mst_users(id),
    updated_by uuid NOT NULL REFERENCES base.mst_users(id)
);

COMMENT ON TABLE budgeting.resource_assignments IS 'EP-009: Employee assignments to project budgets';
COMMENT ON COLUMN budgeting.resource_assignments.employee_id IS 'EP-009-US-002: Links to masterdata.mst_employees instead of users';
COMMENT ON COLUMN budgeting.resource_assignments.status IS 'EP-009-US-005: Simple status for validation workflow';

-- Indexes for resource_assignments
CREATE INDEX IF NOT EXISTS idx_resource_assignments_budget_employee ON budgeting.resource_assignments(budget_id, employee_id);
CREATE INDEX IF NOT EXISTS idx_resource_assignments_employee_month ON budgeting.resource_assignments(employee_id, created_at);
CREATE INDEX IF NOT EXISTS idx_resource_assignments_status_active ON budgeting.resource_assignments(status, updated_at);

-- ===========================================
-- TABLE 3: cost_calculations
-- ===========================================

CREATE TABLE IF NOT EXISTS budgeting.cost_calculations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    assignment_id uuid NOT NULL REFERENCES budgeting.resource_assignments(id) ON DELETE CASCADE,
    cost_type text NOT NULL CHECK (cost_type IN ('labor', 'overhead', 'travel', 'equipment', 'other')),
    direct_cost numeric(12,2) DEFAULT 0,
    indirect_cost numeric(12,2) DEFAULT 0,
    overhead_factor numeric(5,2) DEFAULT 1.0,
    currency text DEFAULT 'EUR',
    calculated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE budgeting.cost_calculations IS 'EP-009: Detailed cost calculations by assignment';
COMMENT ON COLUMN budgeting.cost_calculations.direct_cost IS 'EP-009-US-008: Direct costs (labor, equipment)';
COMMENT ON COLUMN budgeting.cost_calculations.indirect_cost IS 'EP-009-US-008: Indirect costs (overhead, admin)';

-- Indexes for cost_calculations
CREATE INDEX IF NOT EXISTS idx_cost_calculations_assignment_type ON budgeting.cost_calculations(assignment_id, cost_type);
CREATE INDEX IF NOT EXISTS idx_cost_calculations_calculated_at ON budgeting.cost_calculations(calculated_at);

-- ===========================================
-- TABLE 4: masterdata.currency_rates
-- ===========================================

CREATE TABLE IF NOT EXISTS masterdata.currency_rates (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    from_currency text NOT NULL,
    to_currency text NOT NULL,
    rate numeric(12,6) NOT NULL,
    valid_from date NOT NULL,
    valid_until date,
    is_active boolean DEFAULT true,
    source text DEFAULT 'manual',
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    created_by uuid REFERENCES base.mst_users(id)
);

COMMENT ON TABLE masterdata.currency_rates IS 'EP-009-US-007: Currency exchange rates with validity periods';
COMMENT ON COLUMN masterdata.currency_rates.valid_from IS 'EP-009-US-007: Start date for rate validity';
COMMENT ON COLUMN masterdata.currency_rates.valid_until IS 'EP-009-US-007: End date for rate validity';

-- Indexes for currency_rates
CREATE INDEX IF NOT EXISTS idx_currency_rates_active ON masterdata.currency_rates(from_currency, to_currency, valid_from DESC) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_currency_rates_period ON masterdata.currency_rates(valid_from, valid_until);

-- ===========================================
-- TABLE 5: budget_versions
-- ===========================================

CREATE TABLE IF NOT EXISTS budgeting.budget_versions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id uuid NOT NULL REFERENCES budgeting.monthly_budgets(id) ON DELETE CASCADE,
    version_number integer NOT NULL,
    raw_data jsonb NOT NULL,
    metadata jsonb DEFAULT '{}',
    change_reason text,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL REFERENCES base.mst_users(id)
);

COMMENT ON TABLE budgeting.budget_versions IS 'EP-009-US-009: Version control for budgets with raw data for analytics';
COMMENT ON COLUMN budgeting.budget_versions.raw_data IS 'EP-009-US-009: Complete budget data in JSON format';
COMMENT ON COLUMN budgeting.budget_versions.metadata IS 'EP-009-US-009: Additional metadata for analytics';

-- Indexes for budget_versions
CREATE INDEX IF NOT EXISTS idx_budget_versions_budget_version ON budgeting.budget_versions(budget_id, version_number);
CREATE INDEX IF NOT EXISTS idx_budget_versions_created_at ON budgeting.budget_versions(created_at);

-- ===========================================
-- TABLE 6: status_history (UNIFIED)
-- ===========================================

CREATE TABLE IF NOT EXISTS budgeting.status_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    budget_id uuid REFERENCES budgeting.monthly_budgets(id) ON DELETE CASCADE,
    assignment_id uuid REFERENCES budgeting.resource_assignments(id) ON DELETE CASCADE,
    record_type text NOT NULL CHECK (record_type IN ('budget', 'assignment', 'workflow')),
    old_status text,
    new_status text,
    workflow_step text CHECK (workflow_step IN ('draft', 'pending_validation', 'validated', 'submitted_to_cto', 'approved', 'rejected')),
    change_reason text,
    assigned_to uuid REFERENCES base.mst_users(id),
    due_date date,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    changed_by uuid NOT NULL REFERENCES base.mst_users(id),
    CONSTRAINT status_history_has_reference CHECK (
        (record_type = 'budget' AND budget_id IS NOT NULL) OR
        (record_type = 'assignment' AND assignment_id IS NOT NULL) OR
        (record_type = 'workflow' AND budget_id IS NOT NULL)
    )
);

COMMENT ON TABLE budgeting.status_history IS 'EP-009: Unified status history and workflow tracking';
COMMENT ON COLUMN budgeting.status_history.record_type IS 'EP-009-US-005, US-010: Type of record being tracked';
COMMENT ON COLUMN budgeting.status_history.workflow_step IS 'EP-009-US-010: Workflow step in approval process';

-- Indexes for status_history
CREATE INDEX IF NOT EXISTS idx_status_history_budget_timeline ON budgeting.status_history(budget_id, created_at) WHERE budget_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_status_history_assignment_timeline ON budgeting.status_history(assignment_id, created_at) WHERE assignment_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_status_history_workflow_step ON budgeting.status_history(workflow_step, created_at);

-- ===========================================
-- EXTENSIONS TO EXISTING TABLES
-- ===========================================

-- Extension to projects.trn_projects
ALTER TABLE projects.trn_projects
ADD COLUMN IF NOT EXISTS budget_responsible_id uuid REFERENCES base.mst_users(id),
ADD COLUMN IF NOT EXISTS default_target_margin numeric(5,2),
ADD COLUMN IF NOT EXISTS last_budget_update timestamptz;

COMMENT ON COLUMN projects.trn_projects.budget_responsible_id IS 'EP-009-US-001: PM responsible for budget planning';
COMMENT ON COLUMN projects.trn_projects.default_target_margin IS 'EP-009-US-004: Default target margin for budgets';

-- Extension to tasks.trn_task_time_records
ALTER TABLE tasks.trn_task_time_records
ADD COLUMN IF NOT EXISTS budget_allocation numeric(12,2),
ADD COLUMN IF NOT EXISTS cost_category text CHECK (cost_category IN ('direct', 'indirect'));

COMMENT ON COLUMN tasks.trn_task_time_records.budget_allocation IS 'EP-009: Budget allocation for time tracking';
COMMENT ON COLUMN tasks.trn_task_time_records.cost_category IS 'EP-009-US-008: Cost classification for reporting';

-- ===========================================
-- FUNCTIONS
-- ===========================================

-- Function 1: calculate_monthly_budget
CREATE OR REPLACE FUNCTION budgeting.calculate_monthly_budget(p_budget_id uuid)
RETURNS jsonb AS \$\$
DECLARE
    budget_record record;
    total_cost numeric := 0;
    total_margin numeric := 0;
    result jsonb;
BEGIN
    -- Get budget info
    SELECT * INTO budget_record FROM budgeting.monthly_budgets WHERE id = p_budget_id;
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Budget not found');
    END IF;

    -- Calculate total costs from assignments
    SELECT COALESCE(SUM(monthly_cost), 0) INTO total_cost
    FROM budgeting.resource_assignments
    WHERE budget_id = p_budget_id AND status = 'validated';

    -- Calculate margin (assuming revenue is stored elsewhere or calculated)
    -- For now, use target_margin as reference
    total_margin := total_cost * (budget_record.target_margin / 100);

    -- Update budget
    UPDATE budgeting.monthly_budgets
    SET total_cost = total_cost,
        total_margin = total_margin,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_budget_id;

    -- Return result
    result := jsonb_build_object(
        'budget_id', p_budget_id,
        'total_cost', total_cost,
        'total_margin', total_margin,
        'calculated_at', CURRENT_TIMESTAMP
    );

    RETURN result;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.calculate_monthly_budget(uuid) IS 'EP-009-US-003: Calculate total costs and margins for a budget';

-- Function 2: validate_budget_constraints
CREATE OR REPLACE FUNCTION budgeting.validate_budget_constraints(p_budget_id uuid)
RETURNS jsonb AS \$\$
DECLARE
    validation_result jsonb := '{}';
    conflict_count integer := 0;
    assignment_record record;
BEGIN
    -- Check for employee capacity conflicts
    FOR assignment_record IN
        SELECT ra.*, mb.budget_month
        FROM budgeting.resource_assignments ra
        JOIN budgeting.monthly_budgets mb ON ra.budget_id = mb.id
        WHERE ra.budget_id = p_budget_id
    LOOP
        -- Check if employee has other assignments in same month
        SELECT COUNT(*) INTO conflict_count
        FROM budgeting.resource_assignments ra2
        JOIN budgeting.monthly_budgets mb2 ON ra2.budget_id = mb2.id
        WHERE ra2.employee_id = assignment_record.employee_id
        AND ra2.budget_id != assignment_record.budget_id
        AND mb2.budget_month = assignment_record.budget_month
        AND ra2.status = 'validated';

        IF conflict_count > 0 THEN
            validation_result := validation_result || jsonb_build_object(
                'capacity_conflicts',
                (validation_result->>'capacity_conflicts')::integer + 1
            );
        END IF;
    END LOOP;

    -- Add validation timestamp
    validation_result := validation_result || jsonb_build_object(
        'validated_at', CURRENT_TIMESTAMP,
        'budget_id', p_budget_id
    );

    RETURN validation_result;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.validate_budget_constraints(uuid) IS 'EP-009-US-005: Validate budget constraints and capacity conflicts';

-- Function 3: convert_currency
CREATE OR REPLACE FUNCTION budgeting.convert_currency(
    p_amount numeric,
    p_from_currency text,
    p_to_currency text,
    p_date date DEFAULT CURRENT_DATE
)
RETURNS numeric AS \$\$
DECLARE
    rate_record record;
    converted_amount numeric;
BEGIN
    -- If same currency, return original amount
    IF p_from_currency = p_to_currency THEN
        RETURN p_amount;
    END IF;

    -- Find applicable rate
    SELECT * INTO rate_record
    FROM masterdata.currency_rates
    WHERE from_currency = p_from_currency
    AND to_currency = p_to_currency
    AND is_active = true
    AND valid_from <= p_date
    AND (valid_until IS NULL OR valid_until >= p_date)
    ORDER BY valid_from DESC
    LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No exchange rate found for % to % on %', p_from_currency, p_to_currency, p_date;
    END IF;

    converted_amount := p_amount * rate_record.rate;
    RETURN converted_amount;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.convert_currency(numeric, text, text, date) IS 'EP-009-US-007: Convert currency using applicable exchange rates';

-- Function 4: calculate_profitability
CREATE OR REPLACE FUNCTION budgeting.calculate_profitability(
    p_budget_id uuid,
    p_period_type text DEFAULT 'month'
)
RETURNS jsonb AS \$\$
DECLARE
    budget_record record;
    result jsonb;
    profitability_rate numeric;
BEGIN
    SELECT * INTO budget_record FROM budgeting.monthly_budgets WHERE id = p_budget_id;

    IF budget_record.total_cost > 0 THEN
        profitability_rate := (budget_record.total_margin / budget_record.total_cost) * 100;
    ELSE
        profitability_rate := 0;
    END IF;

    result := jsonb_build_object(
        'budget_id', p_budget_id,
        'period_type', p_period_type,
        'total_cost', budget_record.total_cost,
        'total_margin', budget_record.total_margin,
        'profitability_rate', profitability_rate,
        'target_margin', budget_record.target_margin,
        'vs_target', profitability_rate - budget_record.target_margin,
        'calculated_at', CURRENT_TIMESTAMP
    );

    RETURN result;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.calculate_profitability(uuid, text) IS 'EP-009-US-004: Calculate profitability metrics by period type';

-- Function 5: check_capacity_conflicts
CREATE OR REPLACE FUNCTION budgeting.check_capacity_conflicts(
    p_employee_id uuid,
    p_month date,
    p_required_percentage numeric
)
RETURNS jsonb AS \$\$
DECLARE
    total_assigned numeric := 0;
    available_capacity numeric;
    conflict_detected boolean := false;
BEGIN
    -- Calculate total assigned percentage for employee in month
    SELECT COALESCE(SUM(dedication_percentage), 0) INTO total_assigned
    FROM budgeting.resource_assignments ra
    JOIN budgeting.monthly_budgets mb ON ra.budget_id = mb.id
    WHERE ra.employee_id = p_employee_id
    AND DATE_TRUNC('month', mb.budget_month) = DATE_TRUNC('month', p_month)
    AND ra.status = 'validated';

    available_capacity := 100 - total_assigned;

    IF available_capacity < p_required_percentage THEN
        conflict_detected := true;
    END IF;

    RETURN jsonb_build_object(
        'employee_id', p_employee_id,
        'month', p_month,
        'total_assigned', total_assigned,
        'available_capacity', available_capacity,
        'required_percentage', p_required_percentage,
        'conflict_detected', conflict_detected,
        'checked_at', CURRENT_TIMESTAMP
    );
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.check_capacity_conflicts(uuid, date, numeric) IS 'EP-009-US-001: Check employee capacity conflicts for month';

-- Function 6: submit_to_cto_review
CREATE OR REPLACE FUNCTION budgeting.submit_to_cto_review(p_budget_id uuid)
RETURNS jsonb AS \$\$
DECLARE
    budget_record record;
    cto_user_id uuid;
BEGIN
    -- Get budget info
    SELECT * INTO budget_record FROM budgeting.monthly_budgets WHERE id = p_budget_id;
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Budget not found');
    END IF;

    -- Validate budget is ready for submission
    IF budget_record.status != 'validated' THEN
        RETURN jsonb_build_object('error', 'Budget must be validated before submission');
    END IF;

    -- Find CTO (assuming role-based lookup)
    SELECT ru.user_id INTO cto_user_id
    FROM base.rel_user_role_entities ru
    JOIN base.dat_role r ON ru.role_id = r.id
    WHERE r.name = 'cto'
    AND ru.is_active = true
    LIMIT 1;

    -- Update budget status
    UPDATE budgeting.monthly_budgets
    SET status = 'submitted_to_cto',
        submitted_to_cto_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_budget_id;

    -- Record in status history
    INSERT INTO budgeting.status_history (
        budget_id,
        record_type,
        old_status,
        new_status,
        workflow_step,
        change_reason,
        assigned_to,
        changed_by
    ) VALUES (
        p_budget_id,
        'workflow',
        'validated',
        'submitted_to_cto',
        'submitted_to_cto',
        'Automatic submission to CTO review',
        cto_user_id,
        budget_record.updated_by
    );

    RETURN jsonb_build_object(
        'success', true,
        'budget_id', p_budget_id,
        'submitted_to', cto_user_id,
        'submitted_at', CURRENT_TIMESTAMP
    );
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION budgeting.submit_to_cto_review(uuid) IS 'EP-009-US-010: Submit validated budget to CTO for review';

COMMIT;
