-- =============================================================================
-- SEEDS: Cost Calculations for EP-009
-- =============================================================================
-- Purpose: Detailed cost breakdowns by assignment and type
-- Source: Based on resource assignments with realistic cost structures
-- Dependencies: budgeting.trn_resource_assignments
-- =============================================================================

INSERT INTO budgeting.trn_cost_calculations (
    id, assignment_id, cost_type, direct_cost, indirect_cost, 
    overhead_factor, currency, calculated_at
) VALUES
-- Labor costs (direct)
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_resource_assignments LIMIT 1),
    'labor',
    4800.00,
    0.00,
    1.0,
    'EUR',
    CURRENT_TIMESTAMP
),
-- Overhead costs (indirect) for same assignment
(
    gen_random_uuid(),
    (SELECT id FROM budgeting.trn_resource_assignments LIMIT 1),
    'overhead',
    0.00,
    960.00,
    0.2,
    'EUR',
    CURRENT_TIMESTAMP
)
ON CONFLICT DO NOTHING;

SELECT 'Cost calculations inserted:' as status, COUNT(*) as total_calculations FROM budgeting.trn_cost_calculations;
