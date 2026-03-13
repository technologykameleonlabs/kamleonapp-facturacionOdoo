-- =====================================================
-- EP-007: Registro Diario de Tiempo
-- =====================================================
-- Basado en: 03-poc/0301-data-model/030102-dm/time_tracking/
-- Implementa todas las tablas necesarias para EP-007
-- =====================================================

-- Crear esquema funcional para registro de tiempo
CREATE SCHEMA IF NOT EXISTS time_tracking;

-- =====================================================
-- TABLA: trn_time_entries
-- =====================================================
CREATE TABLE IF NOT EXISTS "time_tracking"."trn_time_entries" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "project_id" UUID NOT NULL,
    "task_id" UUID,
    "entry_date" DATE NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "hours_worked" NUMERIC(5,2) NOT NULL CHECK ("hours_worked" > 0),
    "description" TEXT,
    "is_billable" BOOLEAN NOT NULL DEFAULT true,
    "status" TEXT NOT NULL DEFAULT 'DRAFT' CHECK ("status" IN ('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED')),
    "approved_by" UUID,
    "approved_at" TIMESTAMPTZ,
    "rejection_reason" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "fk_trn_time_entries_user_id"
        FOREIGN KEY ("user_id")
        REFERENCES "base"."mst_users"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_entries_project_id"
        FOREIGN KEY ("project_id")
        REFERENCES "projects"."trn_projects"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_entries_task_id"
        FOREIGN KEY ("task_id")
        REFERENCES "tasks"."trn_tasks"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_entries_approved_by"
        FOREIGN KEY ("approved_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_entries_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_entries_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "chk_trn_time_entries_end_after_start"
        CHECK ("end_time" > "start_time")
);

-- =====================================================
-- TABLA: trn_time_breaks
-- =====================================================
CREATE TABLE IF NOT EXISTS "time_tracking"."trn_time_breaks" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "time_entry_id" UUID NOT NULL,
    "break_type" TEXT NOT NULL CHECK ("break_type" IN ('LUNCH', 'COFFEE', 'PERSONAL', 'MEETING', 'OTHER')),
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "duration_minutes" INTEGER NOT NULL CHECK ("duration_minutes" > 0),
    "description" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "fk_trn_time_breaks_time_entry_id"
        FOREIGN KEY ("time_entry_id")
        REFERENCES "time_tracking"."trn_time_entries"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_breaks_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_breaks_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "chk_trn_time_breaks_end_after_start"
        CHECK ("end_time" > "start_time")
);

-- =====================================================
-- TABLA: trn_time_approvals
-- =====================================================
CREATE TABLE IF NOT EXISTS "time_tracking"."trn_time_approvals" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "time_entry_id" UUID NOT NULL,
    "approver_id" UUID NOT NULL,
    "action" TEXT NOT NULL CHECK ("action" IN ('APPROVE', 'REJECT', 'REQUEST_CHANGES')),
    "comments" TEXT,
    "approved_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "fk_trn_time_approvals_time_entry_id"
        FOREIGN KEY ("time_entry_id")
        REFERENCES "time_tracking"."trn_time_entries"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_approvals_approver_id"
        FOREIGN KEY ("approver_id")
        REFERENCES "base"."mst_users"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_approvals_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_time_approvals_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- ÍNDICES
-- =====================================================
CREATE INDEX IF NOT EXISTS "idx_trn_time_entries_user_id" ON "time_tracking"."trn_time_entries" ("user_id");
CREATE INDEX IF NOT EXISTS "idx_trn_time_entries_project_id" ON "time_tracking"."trn_time_entries" ("project_id");
CREATE INDEX IF NOT EXISTS "idx_trn_time_entries_task_id" ON "time_tracking"."trn_time_entries" ("task_id");
CREATE INDEX IF NOT EXISTS "idx_trn_time_entries_entry_date" ON "time_tracking"."trn_time_entries" ("entry_date");
CREATE INDEX IF NOT EXISTS "idx_trn_time_entries_status" ON "time_tracking"."trn_time_entries" ("status");
CREATE INDEX IF NOT EXISTS "idx_trn_time_entries_billable" ON "time_tracking"."trn_time_entries" ("is_billable");

CREATE INDEX IF NOT EXISTS "idx_trn_time_breaks_time_entry_id" ON "time_tracking"."trn_time_breaks" ("time_entry_id");
CREATE INDEX IF NOT EXISTS "idx_trn_time_breaks_break_type" ON "time_tracking"."trn_time_breaks" ("break_type");

CREATE INDEX IF NOT EXISTS "idx_trn_time_approvals_time_entry_id" ON "time_tracking"."trn_time_approvals" ("time_entry_id");
CREATE INDEX IF NOT EXISTS "idx_trn_time_approvals_approver_id" ON "time_tracking"."trn_time_approvals" ("approver_id");
CREATE INDEX IF NOT EXISTS "idx_trn_time_approvals_action" ON "time_tracking"."trn_time_approvals" ("action");

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================
ALTER TABLE "time_tracking"."trn_time_entries" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "time_tracking"."trn_time_breaks" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "time_tracking"."trn_time_approvals" ENABLE ROW LEVEL SECURITY;
