-- =============================================
-- SEED: VISTAS DE ANÁLISIS PARA EP-020 (VERSION FINAL)
-- EP-020 - Sistema de apuntes unificados
-- =============================================

-- Vista detallada básica
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
    ae.reference_model as reference_type
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
LEFT JOIN analytics.mst_analytics_categories ac ON ae.category_id = ac.id
JOIN analytics.mst_analytics_stages as_stage ON ae.stage_id = as_stage.id;

-- Vista de resumen por tipo
CREATE OR REPLACE VIEW analytics.v_entries_by_type AS
SELECT
    aet.name as entry_type,
    aet.category as entry_category,
    COUNT(*) as entries_count,
    SUM(ae.amount) as total_amount,
    AVG(ae.amount) as avg_amount,
    MIN(ae.entry_date) as first_entry,
    MAX(ae.entry_date) as last_entry
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
GROUP BY aet.name, aet.category
ORDER BY aet.name;

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
    'TOTALES GENERALES' as category,
    SUM(CASE WHEN aet.category = 'cost' THEN ae.amount ELSE 0 END) as total_costs,
    SUM(CASE WHEN aet.category = 'revenue' THEN ae.amount ELSE 0 END) as total_revenue,
    SUM(CASE WHEN aet.category = 'revenue' THEN ae.amount ELSE 0 END) -
    SUM(CASE WHEN aet.category = 'cost' THEN ae.amount ELSE 0 END) as net_profit,
    COUNT(*) as total_entries
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado');

-- Vista de entradas pendientes
CREATE OR REPLACE VIEW analytics.v_pending_entries AS
SELECT
    ae.*,
    aet.name as entry_type_name,
    ac.name as category_name,
    as_stage.name as stage_name,
    EXTRACT(DAY FROM (CURRENT_DATE - ae.entry_date)) as days_pending
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
LEFT JOIN analytics.mst_analytics_categories ac ON ae.category_id = ac.id
JOIN analytics.mst_analytics_stages as_stage ON ae.stage_id = as_stage.id
WHERE ae.stage_id IN (
    SELECT id FROM analytics.mst_analytics_stages
    WHERE name IN ('Borrador', 'Pendiente Aprobacion')
)
ORDER BY ae.entry_date DESC;

-- Verificar que las vistas se crearon
SELECT 'VISTAS CREADAS:' as status;
SELECT schemaname, viewname
FROM pg_views
WHERE schemaname = 'analytics'
ORDER BY viewname;
