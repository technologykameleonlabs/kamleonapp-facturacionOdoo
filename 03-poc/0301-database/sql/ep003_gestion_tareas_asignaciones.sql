-- =====================================================
-- EP-003: Gestión de Tareas y Asignaciones
-- =====================================================
-- Basado en: 03-poc/0301-data-model/030102-dm/tasks/
-- Implementa todas las tablas necesarias para EP-003
-- =====================================================

-- Esquema tasks ya existe desde EP-001
-- CREATE SCHEMA IF NOT EXISTS tasks;

-- =====================================================
-- TABLA: mst_task_types - YA EXISTE DESDE EP-001
-- =====================================================
-- Esta tabla ya fue creada en EP-001, no se recrea

-- =====================================================
-- TABLA: mst_task_stages - YA EXISTE DESDE EP-001
-- =====================================================
-- Esta tabla ya fue creada en EP-001, no se recrea

-- =====================================================
-- TABLA: trn_tasks
-- =====================================================
CREATE TABLE IF NOT EXISTS "tasks"."trn_tasks" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "project_id" UUID NOT NULL,
    "type_id" UUID NOT NULL,
    "parent_task_id" UUID,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "priority" TEXT NOT NULL DEFAULT 'MEDIUM' CHECK ("priority" IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    "estimated_hours" NUMERIC(5,2),
    "actual_hours" NUMERIC(5,2) DEFAULT 0,
    "progress_percentage" NUMERIC(5,2) DEFAULT 0.00 CHECK ("progress_percentage" >= 0 AND "progress_percentage" <= 100),
    "planned_start_date" DATE,
    "planned_end_date" DATE,
    "actual_start_date" DATE,
    "actual_end_date" DATE,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "fk_trn_tasks_project_id"
        FOREIGN KEY ("project_id")
        REFERENCES "projects"."trn_projects"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_tasks_type_id"
        FOREIGN KEY ("type_id")
        REFERENCES "tasks"."mst_task_types"("id")
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_tasks_parent_task_id"
        FOREIGN KEY ("parent_task_id")
        REFERENCES "tasks"."trn_tasks"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_tasks_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_tasks_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "chk_trn_tasks_dates"
        CHECK ("planned_end_date" IS NULL OR "planned_start_date" IS NULL OR "planned_end_date" >= "planned_start_date")
);

-- =====================================================
-- TABLA: rel_task_assignments
-- =====================================================
CREATE TABLE IF NOT EXISTS "tasks"."rel_task_assignments" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "task_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "assigned_by" UUID NOT NULL,
    "assigned_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "role" TEXT NOT NULL DEFAULT 'ASSIGNEE' CHECK ("role" IN ('ASSIGNEE', 'REVIEWER', 'OBSERVER')),
    
    CONSTRAINT "uk_rel_task_assignments_task_user"
        UNIQUE ("task_id", "user_id"),
    
    CONSTRAINT "fk_rel_task_assignments_task_id"
        FOREIGN KEY ("task_id")
        REFERENCES "tasks"."trn_tasks"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_rel_task_assignments_user_id"
        FOREIGN KEY ("user_id")
        REFERENCES "base"."mst_users"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_rel_task_assignments_assigned_by"
        FOREIGN KEY ("assigned_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- ÍNDICES (Solo para tablas nuevas)
-- =====================================================
-- Índices para tablas existentes (mst_task_types, mst_task_stages) ya fueron creados en EP-001

CREATE INDEX IF NOT EXISTS "idx_trn_tasks_project_id" ON "tasks"."trn_tasks" ("project_id");
CREATE INDEX IF NOT EXISTS "idx_trn_tasks_type_id" ON "tasks"."trn_tasks" ("type_id");
CREATE INDEX IF NOT EXISTS "idx_trn_tasks_status" ON "tasks"."trn_tasks" ("status");
CREATE INDEX IF NOT EXISTS "idx_trn_tasks_priority" ON "tasks"."trn_tasks" ("priority");
CREATE INDEX IF NOT EXISTS "idx_trn_tasks_parent_task_id" ON "tasks"."trn_tasks" ("parent_task_id");

CREATE INDEX IF NOT EXISTS "idx_rel_task_assignments_task_id" ON "tasks"."rel_task_assignments" ("task_id");
CREATE INDEX IF NOT EXISTS "idx_rel_task_assignments_user_id" ON "tasks"."rel_task_assignments" ("user_id");
CREATE INDEX IF NOT EXISTS "idx_rel_task_assignments_active" ON "tasks"."rel_task_assignments" ("is_active");

-- =====================================================
-- ROW LEVEL SECURITY (Solo para tablas nuevas)
-- =====================================================
-- RLS para tablas existentes ya fue configurado en EP-001
ALTER TABLE "tasks"."trn_tasks" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "tasks"."rel_task_assignments" ENABLE ROW LEVEL SECURITY;
