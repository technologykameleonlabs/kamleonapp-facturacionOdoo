-- =============================================
-- EP-020: VISTAS EXTENDIDAS SIMPLIFICADAS
-- Vistas que cubren análisis por empleado, proyecto y temporal
-- Version simplificada que funciona con tablas existentes
-- =============================================

-- Vista para EP-021: Análisis por empleado (simplificada)
CREATE OR REPLACE VIEW analytics.v_employee_analysis AS
SELECT
    -- Para esta versión, usamos reference_id directamente como employee_id
    -- cuando reference_model = 'employee'
    CASE
        WHEN ae.reference_model = 'employee' THEN ae.reference_id
        ELSE NULL
    END as employee_id,

    -- Nombre del empleado (placeholder - se resolvería en aplicación)
    CASE
        WHEN ae.reference_model = 'employee' THEN 'Empleado-' || ae.reference_id::text
        ELSE 'Sin asignar'
    END as employee_name,

    -- Departamento (placeholder - se resolvería en aplicación)
    CASE
        WHEN ae.reference_model = 'employee' THEN 'Departamento-' || (ae.reference_id::text)
        ELSE 'Sin departamento'
    END as department_name,

    aet.name as entry_type,
    aet.category as cost_type,
    ae.amount,
    ae.entry_date,
    DATE_TRUNC('month', ae.entry_date) as month,
    DATE_TRUNC('year', ae.entry_date) as year,
    ae.reference_model as source_type
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado');

-- Vista para EP-022: Análisis por proyecto y cliente (simplificada)
CREATE OR REPLACE VIEW analytics.v_project_client_analysis AS
SELECT
    -- Usamos reference_id como project_id cuando corresponde
    CASE
        WHEN ae.reference_model IN ('project', 'task_time', 'invoice') THEN ae.reference_id
        ELSE NULL
    END as project_id,

    -- Nombre del proyecto (placeholder)
    CASE
        WHEN ae.reference_model IN ('project', 'task_time', 'invoice') THEN
            'Proyecto-' || ae.reference_id::text
        ELSE 'Sin proyecto'
    END as project_name,

    -- Cliente (placeholder)
    CASE
        WHEN ae.reference_model IN ('project', 'task_time', 'invoice') THEN
            'Cliente-' || ae.reference_id::text
        ELSE 'Sin cliente'
    END as client_name,

    aet.name as entry_type,
    aet.category as cost_type,
    ae.amount,
    ae.entry_date,
    DATE_TRUNC('month', ae.entry_date) as month,
    DATE_TRUNC('year', ae.entry_date) as year,
    ae.reference_model as source_type
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado');

-- Vista para EP-023: Análisis temporal comparativo (completo)
CREATE OR REPLACE VIEW analytics.v_temporal_analysis AS
SELECT
    ae.entry_date,
    DATE_TRUNC('day', ae.entry_date) as day,
    DATE_TRUNC('week', ae.entry_date) as week,
    DATE_TRUNC('month', ae.entry_date) as month,
    DATE_TRUNC('quarter', ae.entry_date) as quarter,
    DATE_TRUNC('year', ae.entry_date) as year,
    EXTRACT(YEAR FROM ae.entry_date) as year_num,
    EXTRACT(MONTH FROM ae.entry_date) as month_num,
    EXTRACT(QUARTER FROM ae.entry_date) as quarter_num,

    aet.name as entry_type,
    aet.category as cost_type,
    ac.name as category,
    ae.amount,

    -- Mes anterior para comparativas
    DATE_TRUNC('month', ae.entry_date - INTERVAL '1 month') as prev_month,

    -- Año anterior para comparativas
    DATE_TRUNC('year', ae.entry_date - INTERVAL '1 year') as prev_year,

    ae.reference_model as source_type

FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
LEFT JOIN analytics.mst_analytics_categories ac ON ae.category_id = ac.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado');

-- Vista de tendencias mensuales (completo)
CREATE OR REPLACE VIEW analytics.v_monthly_trends AS
SELECT
    DATE_TRUNC('month', ae.entry_date) as month,
    aet.category as cost_type,
    COUNT(*) as entries_count,
    SUM(ae.amount) as total_amount,
    AVG(ae.amount) as avg_amount,

    -- Comparación con mes anterior
    LAG(SUM(ae.amount)) OVER (
        PARTITION BY aet.category
        ORDER BY DATE_TRUNC('month', ae.entry_date)
    ) as prev_month_amount,

    -- Cálculo de variación porcentual
    CASE
        WHEN LAG(SUM(ae.amount)) OVER (
            PARTITION BY aet.category
            ORDER BY DATE_TRUNC('month', ae.entry_date)
        ) IS NOT NULL AND LAG(SUM(ae.amount)) OVER (
            PARTITION BY aet.category
            ORDER BY DATE_TRUNC('month', ae.entry_date)
        ) != 0 THEN
            ROUND(
                ((SUM(ae.amount) - LAG(SUM(ae.amount)) OVER (
                    PARTITION BY aet.category
                    ORDER BY DATE_TRUNC('month', ae.entry_date)
                )) / LAG(SUM(ae.amount)) OVER (
                    PARTITION BY aet.category
                    ORDER BY DATE_TRUNC('month', ae.entry_date)
                )) * 100, 2
            )
        ELSE NULL
    END as monthly_variation_percent

FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado')
GROUP BY DATE_TRUNC('month', ae.entry_date), aet.category
ORDER BY month DESC, aet.category;

-- Vista de resumen por tipo de referencia (útil para análisis)
CREATE OR REPLACE VIEW analytics.v_reference_analysis AS
SELECT
    ae.reference_model as dimension,
    COUNT(*) as entries_count,
    SUM(ae.amount) as total_amount,
    AVG(ae.amount) as avg_amount,
    MIN(ae.entry_date) as first_entry,
    MAX(ae.entry_date) as last_entry,
    aet.category as cost_type
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado')
GROUP BY ae.reference_model, aet.category
ORDER BY ae.reference_model, aet.category;

-- Verificar que las vistas se crearon
SELECT 'VISTAS EXTENDIDAS CREADAS:' as status;
SELECT schemaname, viewname
FROM pg_views
WHERE schemaname = 'analytics'
  AND viewname LIKE 'v_%'
ORDER BY viewname;

-- Mostrar ejemplos de cada vista
SELECT 'EJEMPLO VISTA EMPLEADO:' as example;
SELECT employee_name, department_name, entry_type, SUM(amount) as total
FROM analytics.v_employee_analysis
GROUP BY employee_name, department_name, entry_type
ORDER BY total DESC
LIMIT 3;

SELECT 'EJEMPLO VISTA PROYECTO:' as example;
SELECT project_name, client_name, entry_type, SUM(amount) as total
FROM analytics.v_project_client_analysis
GROUP BY project_name, client_name, entry_type
ORDER BY total DESC
LIMIT 3;

SELECT 'EJEMPLO VISTA TEMPORAL:' as example;
SELECT * FROM analytics.v_monthly_trends
ORDER BY month DESC
LIMIT 3;

SELECT 'EJEMPLO VISTA REFERENCIAS:' as example;
SELECT * FROM analytics.v_reference_analysis
ORDER BY dimension, cost_type;
