-- =====================================================
-- EP-001: Configuración de Datos Maestros
-- =====================================================
-- Implementa todas las tablas maestras necesarias para el sistema
-- Incluye: empleados, contactos, entidades, tipos/etapas de proyecto/tarea,
-- plantillas, roles, permisos y glosario de terminología
-- =====================================================

-- Crear enums necesarios
DO $$ BEGIN
    CREATE TYPE masterdata.contact_type_enum AS ENUM ('individual', 'empresa');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE masterdata.employee_status_enum AS ENUM ('activo', 'inactivo', 'suspendido');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE masterdata.stage_status_enum AS ENUM ('activo', 'inactivo', 'archivado');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- =====================================================
-- TABLA: Entidades/Empresas (EP-001-US-008)
-- =====================================================
CREATE TABLE IF NOT EXISTS masterdata.mst_entities (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_code varchar(20) UNIQUE NOT NULL,
    name varchar(255) NOT NULL,
    description text,
    legal_name varchar(255),
    tax_id varchar(50),
    address text,
    city varchar(100),
    country varchar(100),
    phone varchar(20),
    email varchar(255),
    website varchar(255),
    is_active boolean NOT NULL DEFAULT true,
    multi_tenant_config jsonb DEFAULT '{}',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE masterdata.mst_entities IS 'Entidades/empresas para multi-tenancy y separación de datos';
COMMENT ON COLUMN masterdata.mst_entities.entity_code IS 'Código único de la entidad';
COMMENT ON COLUMN masterdata.mst_entities.multi_tenant_config IS 'Configuración específica de multi-tenancy';

-- =====================================================
-- TABLA: Empleados (EP-001-US-001)
-- =====================================================
CREATE TABLE IF NOT EXISTS masterdata.mst_employees (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES base.mst_users(id) ON DELETE CASCADE,
    employee_code varchar(20) UNIQUE NOT NULL,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    email varchar(255) UNIQUE NOT NULL,
    phone varchar(20),
    hourly_rate decimal(10,2) NOT NULL CHECK (hourly_rate > 0),
    hire_date date NOT NULL DEFAULT CURRENT_DATE,
    status masterdata.employee_status_enum NOT NULL DEFAULT 'activo',
    entity_id uuid REFERENCES masterdata.mst_entities(id) ON DELETE RESTRICT,
    department varchar(100),
    position varchar(100),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE masterdata.mst_employees IS 'Empleados del sistema con información básica y tarifas horarias';
COMMENT ON COLUMN masterdata.mst_employees.employee_code IS 'Código único del empleado';
COMMENT ON COLUMN masterdata.mst_employees.hourly_rate IS 'Tarifa horaria del empleado';
COMMENT ON COLUMN masterdata.mst_employees.entity_id IS 'Entidad/empresa a la que pertenece el empleado';

-- =====================================================
-- TABLA: Contactos (EP-001-US-007 + EP-001-US-011)
-- =====================================================
CREATE TABLE IF NOT EXISTS masterdata.mst_contacts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_code varchar(20) UNIQUE NOT NULL,
    first_name varchar(100),
    last_name varchar(100),
    company_name varchar(255),
    contact_type masterdata.contact_type_enum NOT NULL,
    email varchar(255) UNIQUE NOT NULL,
    phone varchar(20),
    mobile varchar(20),
    address text,
    city varchar(100),
    state varchar(100),
    country varchar(100),
    postal_code varchar(20),
    website varchar(255),
    -- Campos extendidos para análisis (EP-001-US-011)
    economic_sector varchar(100),
    country_iso varchar(2), -- ISO 3166-1 alpha-2
    is_active boolean NOT NULL DEFAULT true,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE masterdata.mst_contacts IS 'Contactos de individuos y empresas con información extendida para análisis';
COMMENT ON COLUMN masterdata.mst_contacts.contact_type IS 'Tipo de contacto: individual o empresa';
COMMENT ON COLUMN masterdata.mst_contacts.economic_sector IS 'Sector económico para análisis por cliente';
COMMENT ON COLUMN masterdata.mst_contacts.country_iso IS 'Código ISO del país para segmentación geográfica';

-- =====================================================
-- TABLA: Tipos de Proyecto (EP-001-US-002)
-- =====================================================
CREATE TABLE IF NOT EXISTS projects.mst_project_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    type_code varchar(20) UNIQUE NOT NULL,
    name varchar(100) NOT NULL,
    description text,
    is_active boolean NOT NULL DEFAULT true,
    default_duration_days integer CHECK (default_duration_days > 0),
    color_code varchar(7), -- Hex color for UI
    icon_name varchar(50),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE projects.mst_project_types IS 'Tipos de proyecto para clasificación y estandarización';
COMMENT ON COLUMN projects.mst_project_types.type_code IS 'Código único del tipo de proyecto';
COMMENT ON COLUMN projects.mst_project_types.default_duration_days IS 'Duración por defecto en días';

-- =====================================================
-- TABLA: Etapas de Proyecto (EP-001-US-003)
-- =====================================================
CREATE TABLE IF NOT EXISTS projects.mst_project_stages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    stage_code varchar(20) UNIQUE NOT NULL,
    name varchar(100) NOT NULL,
    description text,
    stage_order integer NOT NULL,
    status masterdata.stage_status_enum NOT NULL DEFAULT 'activo',
    is_milestone boolean NOT NULL DEFAULT false,
    estimated_duration_days integer CHECK (estimated_duration_days > 0),
    color_code varchar(7), -- Hex color for UI
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE projects.mst_project_stages IS 'Etapas estándar del ciclo de vida de proyectos';
COMMENT ON COLUMN projects.mst_project_stages.stage_order IS 'Orden secuencial de la etapa en el flujo';
COMMENT ON COLUMN projects.mst_project_stages.is_milestone IS 'Indica si es una etapa hito importante';

-- =====================================================
-- TABLA: Plantillas de Proyecto (EP-001-US-004)
-- =====================================================
CREATE TABLE IF NOT EXISTS projects.mst_project_templates (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    template_code varchar(20) UNIQUE NOT NULL,
    name varchar(100) NOT NULL,
    description text,
    project_type_id uuid REFERENCES projects.mst_project_types(id) ON DELETE RESTRICT,
    is_active boolean NOT NULL DEFAULT true,
    template_config jsonb DEFAULT '{}',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE projects.mst_project_templates IS 'Plantillas de proyecto con configuración predefinida';
COMMENT ON COLUMN projects.mst_project_templates.template_config IS 'Configuración específica de la plantilla en JSON';

-- =====================================================
-- TABLA: Tipos de Tarea (EP-001-US-005)
-- =====================================================
CREATE TABLE IF NOT EXISTS tasks.mst_task_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    type_code varchar(20) UNIQUE NOT NULL,
    name varchar(100) NOT NULL,
    description text,
    is_active boolean NOT NULL DEFAULT true,
    estimated_hours decimal(5,2) CHECK (estimated_hours > 0),
    color_code varchar(7), -- Hex color for UI
    icon_name varchar(50),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE tasks.mst_task_types IS 'Tipos de tarea para clasificación del trabajo';
COMMENT ON COLUMN tasks.mst_task_types.estimated_hours IS 'Horas estimadas por defecto para este tipo de tarea';

-- =====================================================
-- TABLA: Etapas de Tarea (EP-001-US-006)
-- =====================================================
CREATE TABLE IF NOT EXISTS tasks.mst_task_stages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    stage_code varchar(20) UNIQUE NOT NULL,
    name varchar(100) NOT NULL,
    description text,
    stage_order integer NOT NULL,
    status masterdata.stage_status_enum NOT NULL DEFAULT 'activo',
    is_milestone boolean NOT NULL DEFAULT false,
    color_code varchar(7), -- Hex color for UI
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE tasks.mst_task_stages IS 'Etapas del flujo de trabajo de tareas';
COMMENT ON COLUMN tasks.mst_task_stages.stage_order IS 'Orden secuencial de la etapa en el flujo';

-- =====================================================
-- TABLA: Glosario de Terminología (EP-001-US-012)
-- =====================================================
CREATE TABLE IF NOT EXISTS masterdata.mst_glossary_terms (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    term varchar(50) UNIQUE NOT NULL,
    definition text NOT NULL,
    synonyms text[], -- Array de sinónimos
    related_terms text[], -- Array de términos relacionados
    context varchar(50), -- Contexto de uso (proyectos, usuarios, etc.)
    language varchar(5) NOT NULL DEFAULT 'es',
    is_active boolean NOT NULL DEFAULT true,
    usage_count integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL,
    updated_by uuid REFERENCES base.mst_users(id) ON DELETE SET NULL
);

COMMENT ON TABLE masterdata.mst_glossary_terms IS 'Glosario unificado de terminología del sistema';
COMMENT ON COLUMN masterdata.mst_glossary_terms.synonyms IS 'Lista de sinónimos del término';
COMMENT ON COLUMN masterdata.mst_glossary_terms.related_terms IS 'Lista de términos relacionados';
COMMENT ON COLUMN masterdata.mst_glossary_terms.usage_count IS 'Contador de uso del término en el sistema';