-- =====================================================
-- EP-006: Dashboard de Salud de Proyectos
-- =====================================================
-- Basado en: 03-poc/0301-data-model/030102-dm/d06-progress/
-- Implementa todas las tablas necesarias para EP-006
-- =====================================================

-- Crear esquema (ya existe d06-progress, pero agregamos tablas específicas para dashboard)
-- CREATE SCHEMA IF NOT EXISTS "d06-progress";

-- =====================================================
-- TABLA: trn_project_health_metrics
-- =====================================================
CREATE TABLE IF NOT EXISTS "d06-progress"."trn_project_health_metrics" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "project_id" UUID NOT NULL,
    "metric_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "budget_health" NUMERIC(3,2) NOT NULL CHECK ("budget_health" >= 0 AND "budget_health" <= 1),
    "schedule_health" NUMERIC(3,2) NOT NULL CHECK ("schedule_health" >= 0 AND "schedule_health" <= 1),
    "quality_health" NUMERIC(3,2) NOT NULL CHECK ("quality_health" >= 0 AND "quality_health" <= 1),
    "team_health" NUMERIC(3,2) NOT NULL CHECK ("team_health" >= 0 AND "team_health" <= 1),
    "overall_health" NUMERIC(3,2) NOT NULL CHECK ("overall_health" >= 0 AND "overall_health" <= 1),
    "risk_score" NUMERIC(3,2) NOT NULL CHECK ("risk_score" >= 0 AND "risk_score" <= 1),
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "uk_trn_project_health_metrics_project_date"
        UNIQUE ("project_id", "metric_date"),
    
    CONSTRAINT "fk_trn_project_health_metrics_project_id"
        FOREIGN KEY ("project_id")
        REFERENCES "d02-projects"."trn_projects"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_health_metrics_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "d00-base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_health_metrics_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "d00-base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- TABLA: trn_project_alerts
-- =====================================================
CREATE TABLE IF NOT EXISTS "d06-progress"."trn_project_alerts" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "project_id" UUID NOT NULL,
    "alert_type" TEXT NOT NULL CHECK ("alert_type" IN ('BUDGET_OVERSPEND', 'SCHEDULE_DELAY', 'QUALITY_ISSUE', 'TEAM_CONFLICT', 'RISK_HIGH')),
    "severity" TEXT NOT NULL CHECK ("severity" IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    "title" TEXT NOT NULL,
    "description" TEXT,
    "is_resolved" BOOLEAN NOT NULL DEFAULT false,
    "resolved_at" TIMESTAMPTZ,
    "resolved_by" UUID,
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "fk_trn_project_alerts_project_id"
        FOREIGN KEY ("project_id")
        REFERENCES "d02-projects"."trn_projects"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_alerts_resolved_by"
        FOREIGN KEY ("resolved_by")
        REFERENCES "d00-base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_alerts_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "d00-base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_alerts_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "d00-base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- TABLA: trn_project_kpis
-- =====================================================
CREATE TABLE IF NOT EXISTS "d06-progress"."trn_project_kpis" (
    "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "project_id" UUID NOT NULL,
    "kpi_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "budget_utilization" NUMERIC(5,2) NOT NULL CHECK ("budget_utilization" >= 0),
    "schedule_utilization" NUMERIC(5,2) NOT NULL CHECK ("schedule_utilization" >= 0),
    "team_utilization" NUMERIC(5,2) NOT NULL CHECK ("team_utilization" >= 0),
    "deliverable_completion" NUMERIC(5,2) NOT NULL CHECK ("deliverable_completion" >= 0 AND "deliverable_completion" <= 100),
    "quality_score" NUMERIC(3,2) NOT NULL CHECK ("quality_score" >= 0 AND "quality_score" <= 1),
    "client_satisfaction" NUMERIC(3,2) CHECK ("client_satisfaction" >= 0 AND "client_satisfaction" <= 1),
    "created_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    "created_by" UUID NOT NULL,
    "updated_by" UUID NOT NULL,
    
    CONSTRAINT "uk_trn_project_kpis_project_date"
        UNIQUE ("project_id", "kpi_date"),
    
    CONSTRAINT "fk_trn_project_kpis_project_id"
        FOREIGN KEY ("project_id")
        REFERENCES "d02-projects"."trn_projects"("id")
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_kpis_created_by"
        FOREIGN KEY ("created_by")
        REFERENCES "d00-base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT "fk_trn_project_kpis_updated_by"
        FOREIGN KEY ("updated_by")
        REFERENCES "d00-base"."mst_users"("id")
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- =====================================================
-- ÍNDICES
-- =====================================================
CREATE INDEX IF NOT EXISTS "idx_trn_project_health_metrics_project_id" ON "d06-progress"."trn_project_health_metrics" ("project_id");
CREATE INDEX IF NOT EXISTS "idx_trn_project_health_metrics_metric_date" ON "d06-progress"."trn_project_health_metrics" ("metric_date");
CREATE INDEX IF NOT EXISTS "idx_trn_project_health_metrics_overall_health" ON "d06-progress"."trn_project_health_metrics" ("overall_health");

CREATE INDEX IF NOT EXISTS "idx_trn_project_alerts_project_id" ON "d06-progress"."trn_project_alerts" ("project_id");
CREATE INDEX IF NOT EXISTS "idx_trn_project_alerts_alert_type" ON "d06-progress"."trn_project_alerts" ("alert_type");
CREATE INDEX IF NOT EXISTS "idx_trn_project_alerts_severity" ON "d06-progress"."trn_project_alerts" ("severity");
CREATE INDEX IF NOT EXISTS "idx_trn_project_alerts_resolved" ON "d06-progress"."trn_project_alerts" ("is_resolved");

CREATE INDEX IF NOT EXISTS "idx_trn_project_kpis_project_id" ON "d06-progress"."trn_project_kpis" ("project_id");
CREATE INDEX IF NOT EXISTS "idx_trn_project_kpis_kpi_date" ON "d06-progress"."trn_project_kpis" ("kpi_date");

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================
ALTER TABLE "d06-progress"."trn_project_health_metrics" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "d06-progress"."trn_project_alerts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "d06-progress"."trn_project_kpis" ENABLE ROW LEVEL SECURITY;
