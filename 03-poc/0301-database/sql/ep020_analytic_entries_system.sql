-- =============================================
-- EP-020: SISTEMA DE APUNTES ANALITICOS
-- SQL Idempotente para implementacion completa
-- =============================================

-- Crear esquema analytics si no existe
CREATE SCHEMA IF NOT EXISTS analytics;
COMMENT ON SCHEMA analytics IS 'Sistema de contabilidad analitica con apuntes unificados';

-- =============================================
-- 1. MAESTROS DE SOPORTE
-- =============================================

-- Maestro de tipos de apunte
CREATE TABLE IF NOT EXISTS analytics.mst_entry_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code varchar(20) UNIQUE NOT NULL,
    name varchar(50) NOT NULL,
    description text,
    category varchar(20) NOT NULL CHECK (category IN ('cost', 'revenue', 'adjustment')),
    affects_profit boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    color varchar(7) DEFAULT '#6B7280',
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

-- Insertar tipos básicos (idempotente)
INSERT INTO analytics.mst_entry_types (code, name, description, category, color, sort_order) VALUES
('DIRECT_COST', 'Coste Directo', 'Costes directamente imputables a proyectos', 'cost', '#FF6B6B', 1),
('INDIRECT_COST', 'Coste Indirecto', 'Costes indirectos (reuniones, gestión)', 'cost', '#4ECDC4', 2),
('GENERAL_EXPENSE', 'Gasto General', 'Gastos generales de empresa/departamento', 'cost', '#45B7D1', 3),
('REVENUE', 'Ingreso', 'Ingresos por ventas/consultoría', 'revenue', '#96CEB4', 4),
('ADJUSTMENT', 'Ajuste', 'Ajustes contables o correcciones', 'adjustment', '#FECA57', 5)
ON CONFLICT (code) DO NOTHING;

-- Maestro de categorías
CREATE TABLE IF NOT EXISTS analytics.mst_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code varchar(10) UNIQUE NOT NULL,
    name varchar(50) NOT NULL,
    type varchar(20) NOT NULL CHECK (type IN ('cost', 'revenue')),
    color varchar(7) DEFAULT '#6B7280',
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

-- Insertar categorías básicas (idempotente)
INSERT INTO analytics.mst_categories (code, name, type, color) VALUES
('DEV', 'Desarrollo', 'cost', '#FF6B6B'),
('TEST', 'Testing', 'cost', '#4ECDC4'),
('MEET', 'Reuniones', 'cost', '#45B7D1'),
('TRAV', 'Viajes', 'cost', '#96CEB4'),
('SERV', 'Servicios', 'cost', '#FECA57'),
('SALES', 'Ventas', 'revenue', '#FF9FF3'),
('CONS', 'Consultoría', 'revenue', '#54A0FF')
ON CONFLICT (code) DO NOTHING;

-- Maestro de stages
CREATE TABLE IF NOT EXISTS analytics.mst_entry_stages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code varchar(20) UNIQUE NOT NULL,
    name varchar(50) NOT NULL,
    description text,
    color varchar(7) DEFAULT '#6B7280',
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

-- Insertar stages básicos (idempotente)
INSERT INTO analytics.mst_entry_stages (code, name, description, color, sort_order) VALUES
('DRAFT', 'Borrador', 'Apunte en elaboración, no visible en reportes', '#6B7280', 1),
('PENDING_APPROVAL', 'Pendiente Aprobación', 'Esperando aprobación del workflow', '#F59E0B', 2),
('APPROVED', 'Aprobado', 'Apunte aprobado y activo en reportes', '#10B981', 3),
('REJECTED', 'Rechazado', 'Apunte rechazado, no visible en reportes', '#EF4444', 4)
ON CONFLICT (code) DO NOTHING;

-- =============================================
-- 2. TABLA PRINCIPAL DE APUNTES ANALÍTICOS
-- =============================================

CREATE TABLE IF NOT EXISTS analytics.trn_analytic_entries (
    -- Identificación
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    entry_date date NOT NULL,
    entry_number varchar(20) UNIQUE,

    -- Importes y moneda
    amount decimal(12,2) NOT NULL,
    original_amount decimal(12,2),
    original_currency varchar(3),

    -- Referencias genéricas
    reference_id uuid NOT NULL,
    reference_model varchar(50) NOT NULL,

    -- Clasificación
    entry_type_id uuid NOT NULL REFERENCES analytics.mst_entry_types(id),
    category_id uuid REFERENCES analytics.mst_categories(id),

    -- Stages y workflows
    stage_id uuid NOT NULL REFERENCES analytics.mst_entry_stages(id),
    workflow_id uuid, -- Sin FK por ahora para evitar dependencia de EP-024
    requires_approval boolean DEFAULT false,

    -- Descripción
    description text NOT NULL,
    notes text,

    -- Auditoría
    created_by uuid REFERENCES base.mst_users(id),
    approved_by uuid REFERENCES base.mst_users(id),
    approved_at timestamptz,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Trigger para stage por defecto se crea después de la tabla

-- =============================================
-- 3. ÍNDICES ESTRATÉGICOS
-- =============================================

-- Índices principales
CREATE INDEX IF NOT EXISTS idx_analytic_entries_date ON analytics.trn_analytic_entries(entry_date);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_type ON analytics.trn_analytic_entries(entry_type_id);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_stage ON analytics.trn_analytic_entries(stage_id);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_reference ON analytics.trn_analytic_entries(reference_model, reference_id);

-- Índices compuestos para consultas comunes
CREATE INDEX IF NOT EXISTS idx_analytic_entries_date_type ON analytics.trn_analytic_entries(entry_date, entry_type_id);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_reference_date ON analytics.trn_analytic_entries(reference_model, reference_id, entry_date);

-- =============================================
-- 4. FUNCIONES DE SOPORTE
-- =============================================

-- Función para obtener stage por defecto (Draft)
CREATE OR REPLACE FUNCTION analytics.get_default_stage_id()
RETURNS uuid AS $$
DECLARE
    default_stage_id uuid;
BEGIN
    SELECT id INTO default_stage_id
    FROM analytics.mst_entry_stages
    WHERE code = 'DRAFT' LIMIT 1;

    RETURN default_stage_id;
END;
$$ LANGUAGE plpgsql;

-- Trigger para establecer stage por defecto en INSERT
CREATE OR REPLACE FUNCTION analytics.set_default_stage_trigger()
RETURNS TRIGGER AS $$
BEGIN
    -- Si stage_id es NULL, establecer el stage por defecto
    IF NEW.stage_id IS NULL THEN
        NEW.stage_id := analytics.get_default_stage_id();
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Función para validar referencias
CREATE OR REPLACE FUNCTION analytics.validate_reference(
    p_reference_id uuid,
    p_reference_model varchar(50)
)
RETURNS boolean AS $$
DECLARE
    v_exists boolean := false;
BEGIN
    -- Validar según el modelo de referencia
    CASE p_reference_model
        WHEN 'task_time' THEN
            SELECT EXISTS(SELECT 1 FROM tasks.trn_task_time_records WHERE id = p_reference_id) INTO v_exists;
        WHEN 'project' THEN
            SELECT EXISTS(SELECT 1 FROM projects.trn_projects WHERE id = p_reference_id) INTO v_exists;
        WHEN 'department' THEN
            SELECT EXISTS(SELECT 1 FROM masterdata.mst_departments WHERE id = p_reference_id) INTO v_exists;
        WHEN 'employee' THEN
            SELECT EXISTS(SELECT 1 FROM masterdata.mst_employees WHERE id = p_reference_id) INTO v_exists;
        WHEN 'invoice' THEN
            -- Asumimos que existe tabla de invoices (se puede ajustar)
            SELECT true INTO v_exists; -- Placeholder
        ELSE
            v_exists := false;
    END CASE;

    RETURN v_exists;
END;
$$ LANGUAGE plpgsql;

-- Función para conversión simple de moneda (EUR como base)
CREATE OR REPLACE FUNCTION analytics.convert_to_eur(
    p_amount decimal,
    p_currency varchar(3)
)
RETURNS decimal AS $$
DECLARE
    v_converted_amount decimal;
BEGIN
    -- Si ya está en EUR, devolver sin cambios
    IF p_currency = 'EUR' OR p_currency IS NULL THEN
        RETURN p_amount;
    END IF;

    -- Conversión simple (se puede mejorar con tipos de cambio reales)
    CASE p_currency
        WHEN 'USD' THEN v_converted_amount := p_amount * 0.85;
        WHEN 'GBP' THEN v_converted_amount := p_amount * 1.15;
        ELSE v_converted_amount := p_amount; -- Sin conversión para otras monedas
    END CASE;

    RETURN ROUND(v_converted_amount, 2);
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- 5. TRIGGER PARA CONVERSIÓN AUTOMÁTICA
-- =============================================

-- Trigger para conversion automatica de horas a costes
CREATE OR REPLACE FUNCTION analytics.create_cost_from_time_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_employee_rate decimal(10,2);
    v_total_cost decimal(10,2);
    v_type_id uuid;
    v_category_id uuid;
    v_default_stage_id uuid;
BEGIN
    -- Obtener tarifa del empleado
    SELECT hourly_rate INTO v_employee_rate
    FROM masterdata.mst_employees
    WHERE id = NEW.employee_id;

    -- Si no tiene tarifa, usar valor por defecto
    IF v_employee_rate IS NULL THEN
        v_employee_rate := 50.00; -- €50/hora por defecto
    END IF;

    -- Calcular coste
    v_total_cost := NEW.hours_worked * v_employee_rate;

    -- Obtener IDs de tipo, categoría y stage
    SELECT id INTO v_type_id FROM analytics.mst_entry_types WHERE code = 'DIRECT_COST';
    SELECT id INTO v_category_id FROM analytics.mst_categories WHERE code = 'DEV';
    SELECT id INTO v_default_stage_id FROM analytics.mst_entry_stages WHERE code = 'DRAFT';

    -- Crear apunte analítico
    INSERT INTO analytics.trn_analytic_entries (
        entry_date, amount, original_amount, original_currency,
        reference_id, reference_model,
        entry_type_id, category_id, stage_id,
        description, created_by
    ) VALUES (
        NEW.date, v_total_cost, v_total_cost, 'EUR',
        NEW.id, 'task_time',
        v_type_id, v_category_id, v_default_stage_id,
        NEW.hours_worked || ' horas en tarea', NEW.created_by
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger en task_time_records (solo si existe la tabla)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables
               WHERE table_schema = 'tasks' AND table_name = 'trn_task_time_records') THEN
        CREATE TRIGGER IF NOT EXISTS trigger_create_analytic_entry
            AFTER INSERT ON tasks.trn_task_time_records
            FOR EACH ROW EXECUTE FUNCTION analytics.create_cost_from_time_trigger();
    END IF;
END $$;

-- =============================================
-- 6. VISTAS PARA ANÁLISIS
-- =============================================

-- Vista detallada con resolución de referencias
CREATE OR REPLACE VIEW analytics.v_analytic_entries_detailed AS
SELECT
    ae.*,
    et.name as entry_type_name,
    et.code as entry_type_code,
    et.category as entry_type_category,
    et.color as entry_type_color,
    c.name as category_name,
    c.code as category_code,
    c.color as category_color,
    es.name as stage_name,
    es.code as stage_code,
    es.color as stage_color,

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
    analytics.validate_reference(ae.reference_id, ae.reference_model) as reference_valid

FROM analytics.trn_analytic_entries ae
JOIN analytics.mst_entry_types et ON ae.entry_type_id = et.id
LEFT JOIN analytics.mst_categories c ON ae.category_id = c.id
JOIN analytics.mst_entry_stages es ON ae.stage_id = es.id;

-- Vista de resumen por proyecto
CREATE OR REPLACE VIEW analytics.v_project_summary AS
SELECT
    resolved_project_id as project_id,
    resolved_project_name as project_name,
    COUNT(*) as total_entries,
    SUM(CASE WHEN et.category = 'cost' THEN amount ELSE 0 END) as total_costs,
    SUM(CASE WHEN et.category = 'revenue' THEN amount ELSE 0 END) as total_revenue,
    SUM(CASE WHEN et.category = 'revenue' THEN amount ELSE 0 END) -
    SUM(CASE WHEN et.category = 'cost' THEN amount ELSE 0 END) as profit,
    AVG(amount) as avg_entry_amount
FROM analytics.v_analytic_entries_detailed vaed
JOIN analytics.mst_entry_types et ON vaed.entry_type_id = et.id
WHERE vaed.stage_code = 'APPROVED'
  AND resolved_project_id IS NOT NULL
GROUP BY resolved_project_id, resolved_project_name;

-- =============================================
-- 7. DATOS DE EJEMPLO (SOLO PARA TESTING)
-- =============================================

-- Insertar algunos apuntes de ejemplo (solo si no existen)
INSERT INTO analytics.trn_analytic_entries (
    entry_date, amount, original_amount, original_currency,
    reference_id, reference_model, entry_type_id, category_id,
    description, created_by
)
SELECT
    CURRENT_DATE - INTERVAL '1 day',
    400.00, 400.00, 'EUR',
    '12345678-1234-1234-1234-123456789abc'::uuid, 'task_time',
    et.id, c.id,
    'Ejemplo: 8 horas desarrollo',
    (SELECT id FROM base.mst_users LIMIT 1)
FROM analytics.mst_entry_types et
CROSS JOIN analytics.mst_categories c
WHERE et.code = 'DIRECT_COST'
  AND c.code = 'DEV'
  AND NOT EXISTS (SELECT 1 FROM analytics.trn_analytic_entries WHERE description = 'Ejemplo: 8 horas desarrollo');

-- =============================================
-- 8. TRIGGERS ADICIONALES
-- =============================================

-- Crear trigger para stage por defecto (después de crear las funciones)
CREATE TRIGGER trigger_set_default_stage
    BEFORE INSERT ON analytics.trn_analytic_entries
    FOR EACH ROW EXECUTE FUNCTION analytics.set_default_stage_trigger();

-- =============================================
-- 9. COMENTARIOS Y DOCUMENTACIÓN
-- =============================================

COMMENT ON TABLE analytics.trn_analytic_entries IS 'Tabla central de apuntes analíticos con referencias genéricas';
COMMENT ON TABLE analytics.mst_entry_types IS 'Maestro de tipos de apuntes (coste, ingreso, ajuste)';
COMMENT ON TABLE analytics.mst_categories IS 'Maestro de categorías de apuntes';
COMMENT ON TABLE analytics.mst_entry_stages IS 'Maestro de stages de apuntes (Draft, Pending, Approved, Rejected)';

COMMENT ON COLUMN analytics.trn_analytic_entries.reference_id IS 'ID del objeto referenciado (tarea, proyecto, etc.)';
COMMENT ON COLUMN analytics.trn_analytic_entries.reference_model IS 'Tipo de objeto referenciado';

-- =============================================
-- FIN DEL SCRIPT - EP-020 IMPLEMENTADO
-- =============================================
