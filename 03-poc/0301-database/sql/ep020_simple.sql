-- =============================================
-- EP-020: SISTEMA DE APUNTES ANALITICOS
-- SQL Simple y Ordenado
-- =============================================

-- 1. Crear esquema
CREATE SCHEMA IF NOT EXISTS analytics;

-- 2. Crear maestros primero
CREATE TABLE analytics.mst_analytics_entry_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(50) NOT NULL,
    category varchar(20) NOT NULL,
    color varchar(7) DEFAULT '#6B7280',
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

CREATE TABLE analytics.mst_analytics_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(50) NOT NULL,
    type varchar(20) NOT NULL,
    color varchar(7) DEFAULT '#6B7280',
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

CREATE TABLE analytics.mst_analytics_stages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(50) NOT NULL,
    color varchar(7) DEFAULT '#6B7280',
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

-- 3. Crear tabla principal
CREATE TABLE analytics.trn_analytic_entries (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    entry_date date NOT NULL,
    amount decimal(12,2) NOT NULL,
    original_amount decimal(12,2),
    original_currency varchar(3),
    reference_id uuid NOT NULL,
    reference_model varchar(50) NOT NULL,
    entry_type_id uuid NOT NULL,
    category_id uuid,
    stage_id uuid NOT NULL,
    workflow_id uuid,
    requires_approval boolean DEFAULT false,
    description text NOT NULL,
    notes text,
    created_by uuid,
    approved_by uuid,
    approved_at timestamptz,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- 4. Agregar foreign keys después
ALTER TABLE analytics.trn_analytic_entries
ADD CONSTRAINT fk_entry_type FOREIGN KEY (entry_type_id) REFERENCES analytics.mst_analytics_entry_types(id);

ALTER TABLE analytics.trn_analytic_entries
ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES analytics.mst_analytics_categories(id);

ALTER TABLE analytics.trn_analytic_entries
ADD CONSTRAINT fk_stage FOREIGN KEY (stage_id) REFERENCES analytics.mst_analytics_stages(id);

-- 5. Insertar datos maestros
INSERT INTO analytics.mst_analytics_entry_types (name, category, color, sort_order) VALUES
('Coste Directo', 'cost', '#FF6B6B', 1),
('Coste Indirecto', 'cost', '#4ECDC4', 2),
('Gasto General', 'cost', '#45B7D1', 3),
('Ingreso', 'revenue', '#96CEB4', 4),
('Ajuste', 'adjustment', '#FECA57', 5);

INSERT INTO analytics.mst_analytics_categories (name, type, color) VALUES
('Desarrollo', 'cost', '#FF6B6B'),
('Testing', 'cost', '#4ECDC4'),
('Reuniones', 'cost', '#45B7D1'),
('Viajes', 'cost', '#96CEB4'),
('Servicios', 'cost', '#FECA57'),
('Ventas', 'revenue', '#FF9FF3'),
('Consultoria', 'revenue', '#54A0FF');

INSERT INTO analytics.mst_analytics_stages (name, color, sort_order) VALUES
('Borrador', '#6B7280', 1),
('Pendiente Aprobacion', '#F59E0B', 2),
('Aprobado', '#10B981', 3),
('Rechazado', '#EF4444', 4);

-- 6. Crear índices
CREATE INDEX IF NOT EXISTS idx_analytic_entries_date ON analytics.trn_analytic_entries(entry_date);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_type ON analytics.trn_analytic_entries(entry_type_id);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_stage ON analytics.trn_analytic_entries(stage_id);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_reference ON analytics.trn_analytic_entries(reference_model, reference_id);

-- 7. Función para stage por defecto
CREATE OR REPLACE FUNCTION analytics.get_default_stage_id()
RETURNS uuid AS $$
DECLARE
    default_stage_id uuid;
BEGIN
    SELECT id INTO default_stage_id
    FROM analytics.mst_analytics_stages
    WHERE name = 'Borrador' LIMIT 1;

    RETURN default_stage_id;
END;
$$ LANGUAGE plpgsql;

-- 8. Trigger para stage por defecto
CREATE OR REPLACE FUNCTION analytics.set_default_stage_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.stage_id IS NULL THEN
        NEW.stage_id := analytics.get_default_stage_id();
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 9. Función para conversión automática de horas a costes
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
        v_employee_rate := 50.00;
    END IF;

    -- Calcular coste
    v_total_cost := NEW.hours_worked * v_employee_rate;

    -- Obtener IDs de tipo, categoria y stage
    SELECT id INTO v_type_id FROM analytics.mst_analytics_entry_types WHERE name = 'Coste Directo';
    SELECT id INTO v_category_id FROM analytics.mst_analytics_categories WHERE name = 'Desarrollo';
    SELECT id INTO v_default_stage_id FROM analytics.mst_analytics_stages WHERE name = 'Borrador';

    -- Crear apunte analitico
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

-- 10. Crear triggers
CREATE TRIGGER trigger_set_default_stage
    BEFORE INSERT ON analytics.trn_analytic_entries
    FOR EACH ROW EXECUTE FUNCTION analytics.set_default_stage_trigger();

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

-- 11. Comentarios
COMMENT ON SCHEMA analytics IS 'Sistema de contabilidad analitica con apuntes unificados';
COMMENT ON TABLE analytics.trn_analytic_entries IS 'Tabla central de apuntes analiticos con referencias genericas';
COMMENT ON TABLE analytics.mst_analytics_entry_types IS 'Maestro de tipos de apuntes analiticos';
COMMENT ON TABLE analytics.mst_analytics_categories IS 'Maestro de categorias de apuntes analiticos';
COMMENT ON TABLE analytics.mst_analytics_stages IS 'Maestro de stages de apuntes analiticos';

-- =============================================
-- FIN DEL SCRIPT - EP-020 IMPLEMENTADO
-- =============================================
