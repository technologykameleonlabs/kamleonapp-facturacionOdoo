-- =============================================
-- EP-020: VISTAS EXTENDIDAS PARA EP-021, 022, 023
-- Vistas que cubren análisis por empleado, proyecto y temporal
-- =============================================

-- Vista para EP-021: Análisis por empleado
CREATE OR REPLACE VIEW analytics.v_employee_analysis AS
SELECT
    -- Resolver empleado dinámicamente
    CASE
        WHEN ae.reference_model = 'employee' THEN ae.reference_id
        WHEN ae.reference_model = 'task_time' THEN
            (SELECT ttr.employee_id FROM tasks.trn_task_time_records ttr
             WHERE ttr.id = ae.reference_id)
        ELSE NULL
    END as employee_id,

    -- Obtener nombre del empleado
    CASE
        WHEN ae.reference_model = 'employee' THEN
            (SELECT e.first_name || ' ' || e.last_name FROM masterdata.mst_employees e
             WHERE e.id = ae.reference_id)
        WHEN ae.reference_model = 'task_time' THEN
            (SELECT e.first_name || ' ' || e.last_name FROM tasks.trn_task_time_records ttr
             JOIN masterdata.mst_employees e ON ttr.employee_id = e.id
             WHERE ttr.id = ae.reference_id)
        ELSE 'Sin asignar'
    END as employee_name,

    -- Obtener departamento del empleado
    CASE
        WHEN ae.reference_model = 'employee' THEN
            (SELECT d.name FROM masterdata.mst_employees e
             JOIN masterdata.mst_departments d ON e.department_id = d.id
             WHERE e.id = ae.reference_id)
        WHEN ae.reference_model = 'task_time' THEN
            (SELECT d.name FROM tasks.trn_task_time_records ttr
             JOIN masterdata.mst_employees e ON ttr.employee_id = e.id
             JOIN masterdata.mst_departments d ON e.department_id = d.id
             WHERE ttr.id = ae.reference_id)
        ELSE 'Sin departamento'
    END as department_name,

    aet.name as entry_type,
    aet.category as cost_type,
    ae.amount,
    ae.entry_date,
    DATE_TRUNC('month', ae.entry_date) as month,
    DATE_TRUNC('year', ae.entry_date) as year
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado')
  AND (
      ae.reference_model = 'employee'
      OR ae.reference_model = 'task_time'
  );

-- Vista para EP-022: Análisis por proyecto y cliente
CREATE OR REPLACE VIEW analytics.v_project_client_analysis AS
SELECT
    -- Resolver proyecto dinámicamente
    CASE
        WHEN ae.reference_model = 'project' THEN ae.reference_id
        WHEN ae.reference_model = 'task_time' THEN
            (SELECT ttr.project_id FROM tasks.trn_task_time_records ttr
             WHERE ttr.id = ae.reference_id)
        WHEN ae.reference_model = 'invoice' THEN
            (SELECT i.project_id FROM invoices.trn_invoices i
             WHERE i.id = ae.reference_id)
        ELSE NULL
    END as project_id,

    -- Obtener nombre del proyecto
    CASE
        WHEN ae.reference_model = 'project' THEN
            (SELECT p.name FROM projects.trn_projects p WHERE p.id = ae.reference_id)
        WHEN ae.reference_model = 'task_time' THEN
            (SELECT p.name FROM tasks.trn_task_time_records ttr
             JOIN projects.trn_projects p ON ttr.project_id = p.id
             WHERE ttr.id = ae.reference_id)
        WHEN ae.reference_model = 'invoice' THEN
            (SELECT p.name FROM invoices.trn_invoices i
             JOIN projects.trn_projects p ON i.project_id = p.id
             WHERE i.id = ae.reference_id)
        ELSE 'Sin proyecto'
    END as project_name,

    -- Resolver cliente del proyecto
    CASE
        WHEN ae.reference_model = 'project' THEN
            (SELECT c.company_name FROM projects.trn_projects p
             JOIN masterdata.mst_clients c ON p.client_id = c.id
             WHERE p.id = ae.reference_id)
        WHEN ae.reference_model = 'task_time' THEN
            (SELECT c.company_name FROM tasks.trn_task_time_records ttr
             JOIN projects.trn_projects p ON ttr.project_id = p.id
             JOIN masterdata.mst_clients c ON p.client_id = c.id
             WHERE ttr.id = ae.reference_id)
        WHEN ae.reference_model = 'invoice' THEN
            (SELECT c.company_name FROM invoices.trn_invoices i
             JOIN projects.trn_projects p ON i.project_id = p.id
             JOIN masterdata.mst_clients c ON p.client_id = c.id
             WHERE i.id = ae.reference_id)
        ELSE 'Sin cliente'
    END as client_name,

    aet.name as entry_type,
    aet.category as cost_type,
    ae.amount,
    ae.entry_date,
    DATE_TRUNC('month', ae.entry_date) as month,
    DATE_TRUNC('year', ae.entry_date) as year
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado');

-- Vista para EP-023: Análisis temporal comparativo
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
    DATE_TRUNC('year', ae.entry_date - INTERVAL '1 year') as prev_year

FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
LEFT JOIN analytics.mst_analytics_categories ac ON ae.category_id = ac.id
WHERE ae.stage_id = (SELECT id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado');

-- Vista de tendencias mensuales
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
WHERE employee_id IS NOT NULL
GROUP BY employee_name, department_name, entry_type
LIMIT 5;

SELECT 'EJEMPLO VISTA PROYECTO:' as example;
SELECT project_name, client_name, entry_type, SUM(amount) as total
FROM analytics.v_project_client_analysis
WHERE project_id IS NOT NULL
GROUP BY project_name, client_name, entry_type
LIMIT 5;

SELECT 'EJEMPLO VISTA TEMPORAL:' as example;
SELECT * FROM analytics.v_monthly_trends
ORDER BY month DESC
LIMIT 5;
