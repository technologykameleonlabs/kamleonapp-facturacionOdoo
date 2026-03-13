-- =====================================================
-- EP-002: Creación y Configuración de Proyectos
-- =====================================================
-- Basado en: 03-poc/0301-data-model/030102-dm/projects/projects-ddl.sql
-- Implementa todas las tablas necesarias para EP-002
-- =====================================================

-- Esquema projects ya existe desde EP-001
-- CREATE SCHEMA IF NOT EXISTS projects;

-- =====================================================
-- TABLA: mst_project_types - YA EXISTE DESDE EP-001
-- =====================================================
-- Esta tabla ya fue creada en EP-001, no se recrea

-- =====================================================
-- TABLA: mst_project_stages - YA EXISTE DESDE EP-001
-- =====================================================
-- Esta tabla ya fue creada en EP-001, no se recrea

-- =====================================================
-- TABLA: mst_project_templates - YA EXISTE DESDE EP-001
-- =====================================================
-- Esta tabla ya fue creada en EP-001, no se recrea

-- =====================================================
-- TABLA: trn_projects
-- =====================================================
CREATE TABLE IF NOT EXISTS "projects"."trn_projects" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "entity_id" UUID NOT NULL,
    "type_id" UUID NOT NULL,
    "template_id" UUID,
    "owner_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "priority" TEXT NOT NULL CHECK ("priority" IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    "status" TEXT NOT NULL DEFAULT 'DRAFT',
    "planned_start_date" DATE NOT NULL,
    "planned_end_date" DATE NOT NULL,
    "actual_start_date" DATE,
    "actual_end_date" DATE,
    "budget" NUMERIC(12,2),
    "progress_percentage" NUMERIC(5,2) NOT NULL DEFAULT 0.00 CHECK ("progress_percentage" >= 0 AND "progress_percentage" <= 100),
    "current_stage_id" UUID,
    "config" JSONB,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "uk_trn_projects_entity_code"
        UNIQUE ("entity_id", "code"),
    
    CONSTRAINT "fk_trn_projects_entity_id"
        FOREIGN KEY ("entity_id")
        REFERENCES "masterdata"."mst_entities"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_projects_type_id"
        FOREIGN KEY ("type_id")
        REFERENCES "projects"."mst_project_types"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_projects_template_id"
        FOREIGN KEY ("template_id")
        REFERENCES "projects"."mst_project_templates"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_projects_owner_id"
        FOREIGN KEY ("owner_id")
        REFERENCES "base"."mst_users"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_projects_current_stage_id"
        FOREIGN KEY ("current_stage_id")
        REFERENCES "projects"."mst_project_stages"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "chk_trn_projects_dates"
        CHECK ("planned_end_date" > "planned_start_date"),
    
    CONSTRAINT "chk_trn_projects_actual_dates"
        CHECK ("actual_end_date" IS NULL OR "actual_start_date" IS NOT NULL)
);

-- =====================================================
-- ÍNDICES (Solo para tabla nueva trn_projects)
-- =====================================================
-- Índices para tablas existentes (mst_project_types, mst_project_stages, mst_project_templates) ya fueron creados en EP-001

CREATE INDEX IF NOT EXISTS "idx_trn_projects_entity_code" ON "projects"."trn_projects" ("entity_id", "code");
CREATE INDEX IF NOT EXISTS "idx_trn_projects_entity_id" ON "projects"."trn_projects" ("entity_id");
CREATE INDEX IF NOT EXISTS "idx_trn_projects_type_id" ON "projects"."trn_projects" ("type_id");
CREATE INDEX IF NOT EXISTS "idx_trn_projects_owner_id" ON "projects"."trn_projects" ("owner_id");
CREATE INDEX IF NOT EXISTS "idx_trn_projects_status" ON "projects"."trn_projects" ("status");

-- =====================================================
-- ROW LEVEL SECURITY (Solo para tabla nueva)
-- =====================================================
-- RLS para tablas existentes ya fue configurado en EP-001
ALTER TABLE "projects"."trn_projects" ENABLE ROW LEVEL SECURITY;
