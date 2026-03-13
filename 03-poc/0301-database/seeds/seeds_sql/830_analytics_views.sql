-- =============================================
-- SEED: VISTAS DE ANÁLISIS PARA EP-020
-- EP-020 - Sistema de apuntes unificados
-- =============================================

-- Crear vistas útiles para análisis (si no existen)

-- Vista detallada con resolución automática de referencias
CREATE OR REPLACE VIEW analytics.v_analytic_entries_detailed AS
SELECT
    ae.*,
    aet.name as entry_type_name,
    aet.category as entry_type_category,
    aet.color as entry_type_color,
    ac.name as category_name,
    ac.type as category_type,
    ac.color as category_color,
    as_stage.name as stage_name,
    as_stage.color as stage_color,

    -- Resolver proyecto dinámicamente
    CASE
        WHEN ae.reference_model = 'task_time' THEN
            (SELECT p.id FROM tasks.trn_task_time_records ttr
             JOIN projects.trn_projects p ON ttr.project_id = p.id
             WHERE ttr.id = ae.reference_id)
        WHEN ae.reference_model = 'project' THEN ae.reference_id
        WHEN ae.reference_model = 'invoice' THEN
            (SELECT project_id FROM invoices.trn_invoices WHERE id = ae.reference_id)
        ELSE NULL
    END as resolved_project_id,

    -- Resolver proyecto name dinámicamente
    CASE
        WHEN ae.reference_model = 'task_time' THEN
            (SELECT p.name FROM tasks.trn_task_time_records ttr
             JOIN projects.trn_projects p ON ttr.project_id = p.id
             WHERE ttr.id = ae.reference_id)
        WHEN ae.reference_model = 'project' THEN
            (SELECT name FROM projects.trn_projects WHERE id = ae.reference_id)
        WHEN ae.reference_model = 'invoice' THEN
            (SELECT p.name FROM invoices.trn_invoices i
             JOIN projects.trn_projects p ON i.project_id = p.id
             WHERE i.id = ae.reference_id)
        ELSE NULL
    END as resolved_project_name,

    -- Validar referencia
    CASE
        WHEN ae.reference_model = 'task_time' THEN
            EXISTS(SELECT 1 FROM tasks.trn_task_time_records WHERE id = ae.reference_id)
        WHEN ae.reference_model = 'project' THEN
            EXISTS(SELECT 1 FROM projects.trn_projects WHERE id = ae.reference_id)
        WHEN ae.reference_model = 'department' THEN
            EXISTS(SELECT 1 FROM masterdata.mst_departments WHERE id = ae.reference_id)
        WHEN ae.reference_model = 'employee' THEN
            EXISTS(SELECT 1 FROM masterdata.mst_employees WHERE id = ae.reference_id)
        WHEN ae.reference_model = 'invoice' THEN true
        ELSE false
    END as reference_valid

FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
LEFT JOIN analytics.mst_analytics_categories ac ON ae.category_id = ac.id
JOIN analytics.mst_analytics_stages as_stage ON ae.stage_id = as_stage.id;

-- Vista de resumen por proyecto
CREATE OR REPLACE VIEW analytics.v_project_summary AS
SELECT
    resolved_project_id as project_id,
    resolved_project_name as project_name,
    COUNT(*) as total_entries,
    SUM(CASE WHEN aet.category = 'cost' THEN amount ELSE 0 END) as total_costs,
    SUM(CASE WHEN aet.category = 'revenue' THEN amount ELSE 0 END) as total_revenue,
    SUM(CASE WHEN aet.category = 'revenue' THEN amount ELSE 0 END) -
    SUM(CASE WHEN aet.category = 'cost' THEN amount ELSE 0 END) as profit,
    AVG(amount) as avg_entry_amount
FROM analytics.v_analytic_entries_detailed vaed
JOIN analytics.mst_analytics_entry_types aet ON vaed.entry_type_id = aet.id
WHERE vaed.stage_code = 'Aprobado'
  AND resolved_project_id IS NOT NULL
GROUP BY resolved_project_id, resolved_project_name;

-- Vista de análisis por mes
CREATE OR REPLACE VIEW analytics.v_monthly_analysis AS
SELECT
    DATE_TRUNC('month', ae.entry_date) as month,
    aet.name as entry_type,
    ac.name as category,
    COUNT(*) as entries_count,
    SUM(ae.amount) as total_amount,
    AVG(ae.amount) as avg_amount
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
LEFT JOIN analytics.mst_analytics_categories ac ON ae.category_id = ac.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado')
GROUP BY DATE_TRUNC('month', ae.entry_date), aet.name, ac.name
ORDER BY month DESC, aet.name, ac.name;

-- Vista de balance general
CREATE OR REPLACE VIEW analytics.v_balance_summary AS
SELECT
    'TOTALES' as category,
    SUM(CASE WHEN aet.category = 'cost' THEN ae.amount ELSE 0 END) as total_costs,
    SUM(CASE WHEN aet.category = 'revenue' THEN ae.amount ELSE 0 END) as total_revenue,
    SUM(CASE WHEN aet.category = 'revenue' THEN ae.amount ELSE 0 END) -
    SUM(CASE WHEN aet.category = 'cost' THEN ae.amount ELSE 0 END) as net_profit,
    COUNT(*) as total_entries
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado');

-- Verificar que las vistas se crearon
SELECT 'VISTAS CREADAS:' as status;
SELECT schemaname, viewname
FROM pg_views
WHERE schemaname = 'analytics'
ORDER BY viewname;
