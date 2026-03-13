-- =====================================================
-- EP-004: Seguimiento de Progreso de Proyectos
-- =====================================================
-- Basado en: 03-poc/0301-data-model/030102-dm/progress/
-- Implementa todas las tablas necesarias para EP-004
-- =====================================================

-- Crear esquema funcional para seguimiento de progreso
CREATE SCHEMA IF NOT EXISTS progress;

-- =====================================================
-- TABLA: trn_progress_updates
-- =====================================================
CREATE TABLE IF NOT EXISTS "progress"."trn_progress_updates" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "project_id" UUID NOT NULL,
    "task_id" UUID,
    "user_id" UUID NOT NULL,
    "progress_percentage" NUMERIC(5,2) NOT NULL CHECK ("progress_percentage" >= 0 AND "progress_percentage" <= 100),
    "status" TEXT NOT NULL,
    "notes" TEXT,
    "update_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "fk_trn_progress_updates_project_id"
        FOREIGN KEY ("project_id")
        REFERENCES "projects"."trn_projects"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_progress_updates_task_id"
        FOREIGN KEY ("task_id")
        REFERENCES "tasks"."trn_tasks"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_progress_updates_user_id"
        FOREIGN KEY ("user_id")
        REFERENCES "base"."mst_users"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_progress_updates_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_progress_updates_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- TABLA: trn_milestones
-- =====================================================
CREATE TABLE IF NOT EXISTS "progress"."trn_milestones" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "project_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "planned_date" DATE NOT NULL,
    "actual_date" DATE,
    "status" TEXT NOT NULL DEFAULT 'PENDING' CHECK ("status" IN ('PENDING', 'COMPLETED', 'DELAYED', 'CANCELLED')),
    "is_critical" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "fk_trn_milestones_project_id"
        FOREIGN KEY ("project_id")
        REFERENCES "projects"."trn_projects"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_milestones_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_milestones_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- TABLA: trn_project_health
-- =====================================================
CREATE TABLE IF NOT EXISTS "progress"."trn_project_health" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "project_id" UUID NOT NULL,
    "health_score" NUMERIC(3,2) NOT NULL CHECK ("health_score" >= 0 AND "health_score" <= 1),
    "budget_variance" NUMERIC(10,2),
    "schedule_variance" INTEGER,
    "quality_score" NUMERIC(3,2),
    "risk_level" TEXT NOT NULL CHECK ("risk_level" IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    "assessment_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "uk_trn_project_health_project_date"
        UNIQUE ("project_id", "assessment_date"),
    
    CONSTRAINT "fk_trn_project_health_project_id"
        FOREIGN KEY ("project_id")
        REFERENCES "projects"."trn_projects"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_health_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_health_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- ÍNDICES
-- =====================================================
CREATE INDEX IF NOT EXISTS "idx_trn_progress_updates_project_id" ON "progress"."trn_progress_updates" ("project_id");
CREATE INDEX IF NOT EXISTS "idx_trn_progress_updates_task_id" ON "progress"."trn_progress_updates" ("task_id");
CREATE INDEX IF NOT EXISTS "idx_trn_progress_updates_user_id" ON "progress"."trn_progress_updates" ("user_id");
CREATE INDEX IF NOT EXISTS "idx_trn_progress_updates_update_date" ON "progress"."trn_progress_updates" ("update_date");

CREATE INDEX IF NOT EXISTS "idx_trn_milestones_project_id" ON "progress"."trn_milestones" ("project_id");
CREATE INDEX IF NOT EXISTS "idx_trn_milestones_status" ON "progress"."trn_milestones" ("status");
CREATE INDEX IF NOT EXISTS "idx_trn_milestones_planned_date" ON "progress"."trn_milestones" ("planned_date");

CREATE INDEX IF NOT EXISTS "idx_trn_project_health_project_id" ON "progress"."trn_project_health" ("project_id");
CREATE INDEX IF NOT EXISTS "idx_trn_project_health_assessment_date" ON "progress"."trn_project_health" ("assessment_date");
CREATE INDEX IF NOT EXISTS "idx_trn_project_health_risk_level" ON "progress"."trn_project_health" ("risk_level");

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================
ALTER TABLE "progress"."trn_progress_updates" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "progress"."trn_milestones" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "progress"."trn_project_health" ENABLE ROW LEVEL SECURITY;
