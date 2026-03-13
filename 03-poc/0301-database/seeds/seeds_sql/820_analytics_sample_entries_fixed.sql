-- =============================================
-- SEED: APUNTES DE EJEMPLO PARA TESTING (VERSION CORREGIDA)
-- EP-020 - Sistema de apuntes unificados
-- =============================================

-- Primero verificar qué IDs existen en las tablas maestras
DO $$
DECLARE
    v_coste_directo_id uuid;
    v_coste_indirecto_id uuid;
    v_gasto_general_id uuid;
    v_ingreso_id uuid;
    v_desarrollo_id uuid;
    v_viajes_id uuid;
    v_ventas_id uuid;
    v_aprobado_id uuid;
    v_borrador_id uuid;
BEGIN
    -- Obtener IDs de tipos (usando las tablas que realmente existen)
    SELECT id INTO v_coste_directo_id FROM analytics.mst_analytics_entry_types WHERE name = 'Coste Directo';
    SELECT id INTO v_coste_indirecto_id FROM analytics.mst_analytics_entry_types WHERE name = 'Coste Indirecto';
    SELECT id INTO v_gasto_general_id FROM analytics.mst_analytics_entry_types WHERE name = 'Gasto General';
    SELECT id INTO v_ingreso_id FROM analytics.mst_analytics_entry_types WHERE name = 'Ingreso';

    -- Obtener IDs de categorías
    SELECT id INTO v_desarrollo_id FROM analytics.mst_analytics_categories WHERE name = 'Desarrollo';
    SELECT id INTO v_viajes_id FROM analytics.mst_analytics_categories WHERE name = 'Viajes';
    SELECT id INTO v_ventas_id FROM analytics.mst_analytics_categories WHERE name = 'Ventas';

    -- Obtener IDs de stages
    SELECT id INTO v_aprobado_id FROM analytics.mst_analytics_stages WHERE name = 'Aprobado';
    SELECT id INTO v_borrador_id FROM analytics.mst_analytics_stages WHERE name = 'Borrador';

    -- Verificar que tenemos todos los IDs necesarios
    RAISE NOTICE 'Coste Directo ID: %', v_coste_directo_id;
    RAISE NOTICE 'Desarrollo ID: %', v_desarrollo_id;
    RAISE NOTICE 'Aprobado ID: %', v_aprobado_id;

    -- Si algún ID es NULL, mostrar error
    IF v_coste_directo_id IS NULL OR v_desarrollo_id IS NULL OR v_aprobado_id IS NULL THEN
        RAISE EXCEPTION 'Faltan IDs necesarios. Coste Directo: %, Desarrollo: %, Aprobado: %',
                       v_coste_directo_id, v_desarrollo_id, v_aprobado_id;
    END IF;

    -- Insertar apuntes de ejemplo (solo si no existen)
    -- Costes directos de desarrollo
    INSERT INTO analytics.trn_analytic_entries (
        entry_date, amount, reference_id, reference_model,
        entry_type_id, category_id, stage_id,
        description, created_by
    ) VALUES
    (CURRENT_DATE - INTERVAL '7 days', 2400.00, gen_random_uuid(), 'task_time',
     v_coste_directo_id, v_desarrollo_id, v_aprobado_id,
     'Desarrollo módulo de autenticación - 48 horas', gen_random_uuid()),

    (CURRENT_DATE - INTERVAL '5 days', 1800.00, gen_random_uuid(), 'task_time',
     v_coste_directo_id, v_desarrollo_id, v_aprobado_id,
     'Implementación API REST - 36 horas', gen_random_uuid()),

    (CURRENT_DATE - INTERVAL '3 days', 1200.00, gen_random_uuid(), 'task_time',
     v_coste_directo_id, v_desarrollo_id, v_borrador_id,
     'Testing unitario - 24 horas', gen_random_uuid());

    -- Costes indirectos
    IF v_coste_indirecto_id IS NOT NULL THEN
        INSERT INTO analytics.trn_analytic_entries (
            entry_date, amount, reference_id, reference_model,
            entry_type_id, category_id, stage_id,
            description, created_by
        ) VALUES
        (CURRENT_DATE - INTERVAL '6 days', 600.00, gen_random_uuid(), 'department',
         v_coste_indirecto_id, NULL, v_aprobado_id,
         'Reunión semanal de equipo - 12 horas', gen_random_uuid()),

        (CURRENT_DATE - INTERVAL '2 days', 300.00, gen_random_uuid(), 'department',
         v_coste_indirecto_id, NULL, v_aprobado_id,
         'Revisión de código - 6 horas', gen_random_uuid());
    END IF;

    -- Gastos generales
    IF v_gasto_general_id IS NOT NULL THEN
        INSERT INTO analytics.trn_analytic_entries (
            entry_date, amount, reference_id, reference_model,
            entry_type_id, category_id, stage_id,
            description, created_by
        ) VALUES
        (CURRENT_DATE - INTERVAL '10 days', 800.00, gen_random_uuid(), 'company',
         v_gasto_general_id, NULL, v_aprobado_id,
         'Licencias software enero 2025', gen_random_uuid());
    END IF;

    -- Gastos con categoría
    IF v_coste_indirecto_id IS NOT NULL AND v_viajes_id IS NOT NULL THEN
        INSERT INTO analytics.trn_analytic_entries (
            entry_date, amount, reference_id, reference_model,
            entry_type_id, category_id, stage_id,
            description, created_by
        ) VALUES
        (CURRENT_DATE - INTERVAL '1 day', 150.00, gen_random_uuid(), 'project',
         v_coste_indirecto_id, v_viajes_id, v_borrador_id,
         'Taxi reunión cliente Madrid', gen_random_uuid());
    END IF;

    -- Ingresos
    IF v_ingreso_id IS NOT NULL AND v_ventas_id IS NOT NULL THEN
        INSERT INTO analytics.trn_analytic_entries (
            entry_date, amount, reference_id, reference_model,
            entry_type_id, category_id, stage_id,
            description, created_by
        ) VALUES
        (CURRENT_DATE - INTERVAL '8 days', 5000.00, gen_random_uuid(), 'invoice',
         v_ingreso_id, v_ventas_id, v_aprobado_id,
         'Factura desarrollo e-commerce módulo', gen_random_uuid()),

        (CURRENT_DATE - INTERVAL '4 days', 3000.00, gen_random_uuid(), 'invoice',
         v_ingreso_id, v_ventas_id, v_aprobado_id,
         'Consultoría sistema de inventario', gen_random_uuid());
    END IF;

    RAISE NOTICE 'Apuntes de ejemplo insertados exitosamente';

END $$;

-- Verificar que los apuntes se crearon
SELECT 'APUNTES CREADOS:' as status;
SELECT
    ae.entry_date,
    aet.name as tipo,
    ac.name as categoria,
    ae.amount,
    as_stage.name as stage,
    ae.description
FROM analytics.trn_analytic_entries ae
LEFT JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
LEFT JOIN analytics.mst_analytics_categories ac ON ae.category_id = ac.id
LEFT JOIN analytics.mst_analytics_stages as_stage ON ae.stage_id = as_stage.id
ORDER BY ae.entry_date DESC;

-- Resumen por tipo
SELECT 'RESUMEN POR TIPO:' as status;
SELECT
    aet.name as tipo,
    COUNT(*) as cantidad,
    SUM(ae.amount) as total
FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_analytics_entry_types aet ON ae.entry_type_id = aet.id
GROUP BY aet.name
ORDER BY aet.name;
