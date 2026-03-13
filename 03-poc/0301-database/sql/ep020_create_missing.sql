-- =============================================
-- EP-020: CREAR SOLO LAS TABLAS FALTANTES
-- Script para completar la implementación
-- =============================================

-- Crear esquema si no existe
CREATE SCHEMA IF NOT EXISTS analytics;

-- Crear tablas solo si no existen
CREATE TABLE IF NOT EXISTS analytics.mst_analytics_entry_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(50) NOT NULL,
    category varchar(20) NOT NULL,
    color varchar(7) DEFAULT '#6B7280',
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS analytics.mst_analytics_categories (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(50) NOT NULL,
    type varchar(20) NOT NULL,
    color varchar(7) DEFAULT '#6B7280',
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS analytics.mst_analytics_stages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(50) NOT NULL,
    color varchar(7) DEFAULT '#6B7280',
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS analytics.trn_analytic_entries (
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

-- Agregar foreign keys si no existen
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_name = 'fk_entry_type'
                   AND table_schema = 'analytics') THEN
        ALTER TABLE analytics.trn_analytic_entries
        ADD CONSTRAINT fk_entry_type FOREIGN KEY (entry_type_id)
        REFERENCES analytics.mst_analytics_entry_types(id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_name = 'fk_category'
                   AND table_schema = 'analytics') THEN
        ALTER TABLE analytics.trn_analytic_entries
        ADD CONSTRAINT fk_category FOREIGN KEY (category_id)
        REFERENCES analytics.mst_analytics_categories(id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_name = 'fk_stage'
                   AND table_schema = 'analytics') THEN
        ALTER TABLE analytics.trn_analytic_entries
        ADD CONSTRAINT fk_stage FOREIGN KEY (stage_id)
        REFERENCES analytics.mst_analytics_stages(id);
    END IF;
END $$;

-- Insertar datos maestros si no existen
INSERT INTO analytics.mst_analytics_entry_types (name, category, color, sort_order)
VALUES
('Coste Directo', 'cost', '#FF6B6B', 1),
('Coste Indirecto', 'cost', '#4ECDC4', 2),
('Gasto General', 'cost', '#45B7D1', 3),
('Ingreso', 'revenue', '#96CEB4', 4),
('Ajuste', 'adjustment', '#FECA57', 5)
ON CONFLICT DO NOTHING;

INSERT INTO analytics.mst_analytics_categories (name, type, color)
VALUES
('Desarrollo', 'cost', '#FF6B6B'),
('Testing', 'cost', '#4ECDC4'),
('Reuniones', 'cost', '#45B7D1'),
('Viajes', 'cost', '#96CEB4'),
('Servicios', 'cost', '#FECA57'),
('Ventas', 'revenue', '#FF9FF3'),
('Consultoria', 'revenue', '#54A0FF')
ON CONFLICT DO NOTHING;

INSERT INTO analytics.mst_analytics_stages (name, color, sort_order)
VALUES
('Borrador', '#6B7280', 1),
('Pendiente Aprobacion', '#F59E0B', 2),
('Aprobado', '#10B981', 3),
('Rechazado', '#EF4444', 4)
ON CONFLICT DO NOTHING;

-- Crear índices si no existen
CREATE INDEX IF NOT EXISTS idx_analytic_entries_date ON analytics.trn_analytic_entries(entry_date);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_type ON analytics.trn_analytic_entries(entry_type_id);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_stage ON analytics.trn_analytic_entries(stage_id);
CREATE INDEX IF NOT EXISTS idx_analytic_entries_reference ON analytics.trn_analytic_entries(reference_model, reference_id);

-- Crear funciones si no existen
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

CREATE OR REPLACE FUNCTION analytics.set_default_stage_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.stage_id IS NULL THEN
        NEW.stage_id := analytics.get_default_stage_id();
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger si no existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.triggers
                   WHERE trigger_name = 'trigger_set_default_stage'
                   AND event_object_schema = 'analytics') THEN
        CREATE TRIGGER trigger_set_default_stage
            BEFORE INSERT ON analytics.trn_analytic_entries
            FOR EACH ROW EXECUTE FUNCTION analytics.set_default_stage_trigger();
    END IF;
END $$;

-- Comentarios
COMMENT ON SCHEMA analytics IS 'Sistema de contabilidad analitica con apuntes unificados';
COMMENT ON TABLE analytics.trn_analytic_entries IS 'Tabla central de apuntes analiticos con referencias genericas';
COMMENT ON TABLE analytics.mst_analytics_entry_types IS 'Maestro de tipos de apuntes analiticos';
COMMENT ON TABLE analytics.mst_analytics_categories IS 'Maestro de categorias de apuntes analiticos';
COMMENT ON TABLE analytics.mst_analytics_stages IS 'Maestro de stages de apuntes analiticos';

-- Verificar resultado
SELECT 'TABLAS CREADAS:' as status;
SELECT schemaname, tablename
FROM pg_tables
WHERE schemaname = 'analytics'
ORDER BY tablename;

SELECT 'TIPOS DE APUNTES:' as status;
SELECT name, category, color
FROM analytics.mst_analytics_entry_types
ORDER BY sort_order;

SELECT 'CATEGORÍAS:' as status;
SELECT name, type, color
FROM analytics.mst_analytics_categories
ORDER BY name;

SELECT 'STAGES:' as status;
SELECT name, color
FROM analytics.mst_analytics_stages
ORDER BY sort_order;
