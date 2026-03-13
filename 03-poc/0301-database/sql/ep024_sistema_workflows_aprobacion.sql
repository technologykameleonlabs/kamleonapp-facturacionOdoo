-- EP-024: Sistema Genérico de Workflows de Aprobación
-- Creación de esquema y tablas para sistema unificado de flujos de aprobación
-- MIGRACIÓN: Renombrar tablas existentes a nomenclatura correcta

-- =====================================================
-- MIGRACIÓN: Renombrar tablas existentes (si existen)
-- =====================================================

-- Renombrar tablas con prefijos incorrectos
DO $$
BEGIN
    -- Renombrar workflow_stages -> mst_workflow_stages (si existe)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'approval' AND table_name = 'workflow_stages') THEN
        ALTER TABLE approval.workflow_stages RENAME TO mst_workflow_stages;
    END IF;

    -- Renombrar entity_workflows -> trn_entity_workflows (si existe)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'approval' AND table_name = 'entity_workflows') THEN
        ALTER TABLE approval.entity_workflows RENAME TO trn_entity_workflows;
    END IF;

    -- Renombrar workflow_approvals -> log_workflow_approvals (si existe)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'approval' AND table_name = 'workflow_approvals') THEN
        ALTER TABLE approval.workflow_approvals RENAME TO log_workflow_approvals;
    END IF;

    -- Renombrar workflow_notifications -> cfg_workflow_notifications (si existe)
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'approval' AND table_name = 'workflow_notifications') THEN
        ALTER TABLE approval.workflow_notifications RENAME TO cfg_workflow_notifications;
    END IF;
END $$;

-- =====================================================
-- ESQUEMA: approval
-- =====================================================

CREATE SCHEMA IF NOT EXISTS approval;
COMMENT ON SCHEMA approval IS 'Sistema genérico de workflows de aprobación para cualquier entidad del sistema';

-- =====================================================
-- TABLA 1: Workflows Maestros
-- =====================================================

CREATE TABLE IF NOT EXISTS approval.mst_workflows (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(255) NOT NULL,
    description text,
    icon varchar(100),
    entity_type varchar(100) NOT NULL, -- 'budget', 'project', 'task', etc.
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL,
    updated_by uuid NOT NULL,

    CONSTRAINT uk_mst_workflows_name_entity UNIQUE (name, entity_type)
);

COMMENT ON TABLE approval.mst_workflows IS 'Definición de workflows maestros reutilizables por tipo de entidad';
COMMENT ON COLUMN approval.mst_workflows.entity_type IS 'Tipo de entidad que puede usar este workflow (budget, project, task, etc.)';

-- Índices para mst_workflows
CREATE INDEX IF NOT EXISTS idx_mst_workflows_entity_type ON approval.mst_workflows(entity_type) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_mst_workflows_active ON approval.mst_workflows(is_active) WHERE is_active = true;

-- =====================================================
-- TABLA 2: Etapas de Workflow
-- =====================================================

CREATE TABLE IF NOT EXISTS approval.mst_workflow_stages (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_id uuid NOT NULL,
    stage_order integer NOT NULL,
    name varchar(255) NOT NULL,
    description text,
    required_role varchar(100) NOT NULL,
    approval_type varchar(50) DEFAULT 'single', -- 'single', 'quorum', 'any'
    timeout_hours integer DEFAULT 24,
    can_reject boolean DEFAULT true,
    requires_comment_on_reject boolean DEFAULT true,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_mst_workflow_stages_workflow FOREIGN KEY (workflow_id)
        REFERENCES approval.mst_workflows(id) ON DELETE CASCADE,
    CONSTRAINT uk_mst_workflow_stages_workflow_order UNIQUE (workflow_id, stage_order),
    CONSTRAINT chk_approval_type CHECK (approval_type IN ('single', 'quorum', 'any')),
    CONSTRAINT chk_timeout_positive CHECK (timeout_hours > 0)
);

COMMENT ON TABLE approval.mst_workflow_stages IS 'Definición de etapas secuenciales para cada workflow';
COMMENT ON COLUMN approval.mst_workflow_stages.approval_type IS 'Tipo de aprobación: single (un aprobador), quorum (todos), any (cualquiera)';
COMMENT ON COLUMN approval.mst_workflow_stages.required_role IS 'Rol requerido para aprobar esta etapa';

-- Índices para mst_workflow_stages
CREATE INDEX IF NOT EXISTS idx_mst_workflow_stages_workflow ON approval.mst_workflow_stages(workflow_id);
CREATE INDEX IF NOT EXISTS idx_mst_workflow_stages_role ON approval.mst_workflow_stages(required_role);

-- =====================================================
-- TABLA 3: Asignación de Workflows a Entidades
-- =====================================================

CREATE TABLE IF NOT EXISTS approval.trn_entity_workflows (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type varchar(100) NOT NULL,
    entity_id uuid NOT NULL,
    workflow_id uuid NOT NULL,
    status varchar(50) DEFAULT 'pending', -- 'pending', 'in_progress', 'approved', 'rejected', 'cancelled'
    current_stage_id uuid,
    assigned_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamptz,
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_trn_entity_workflows_workflow FOREIGN KEY (workflow_id)
        REFERENCES approval.mst_workflows(id),
    CONSTRAINT fk_trn_entity_workflows_current_stage FOREIGN KEY (current_stage_id)
        REFERENCES approval.mst_workflow_stages(id),
    CONSTRAINT chk_trn_entity_workflows_status CHECK (status IN ('pending', 'in_progress', 'approved', 'rejected', 'cancelled')),
    CONSTRAINT uk_trn_entity_workflows_entity_active UNIQUE (entity_type, entity_id)
);

COMMENT ON TABLE approval.trn_entity_workflows IS 'Asignación de workflows específicos a objetos concretos del sistema';
COMMENT ON COLUMN approval.trn_entity_workflows.entity_type IS 'Tipo de entidad (budget, project, task, etc.)';
COMMENT ON COLUMN approval.trn_entity_workflows.entity_id IS 'ID del objeto específico';

-- Índices para trn_entity_workflows
CREATE INDEX IF NOT EXISTS idx_trn_entity_workflows_entity ON approval.trn_entity_workflows(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_trn_entity_workflows_workflow ON approval.trn_entity_workflows(workflow_id);
CREATE INDEX IF NOT EXISTS idx_trn_entity_workflows_status ON approval.trn_entity_workflows(status);
CREATE INDEX IF NOT EXISTS idx_trn_entity_workflows_current_stage ON approval.trn_entity_workflows(current_stage_id);

-- =====================================================
-- TABLA 4: Historial de Aprobaciones
-- =====================================================

CREATE TABLE IF NOT EXISTS approval.log_workflow_approvals (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_workflow_id uuid NOT NULL,
    stage_id uuid NOT NULL,
    approver_id uuid NOT NULL,
    decision varchar(50) NOT NULL, -- 'approved', 'rejected', 'delegated', 'escalated'
    decision_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    comments text,
    metadata jsonb DEFAULT '{}',
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_log_workflow_approvals_entity_workflow FOREIGN KEY (entity_workflow_id)
        REFERENCES approval.trn_entity_workflows(id) ON DELETE CASCADE,
    CONSTRAINT fk_log_workflow_approvals_stage FOREIGN KEY (stage_id)
        REFERENCES approval.mst_workflow_stages(id),
    CONSTRAINT chk_log_workflow_approvals_decision CHECK (decision IN ('approved', 'rejected', 'delegated', 'escalated'))
);

COMMENT ON TABLE approval.log_workflow_approvals IS 'Historial completo e inmutable de todas las decisiones de aprobación';
COMMENT ON COLUMN approval.log_workflow_approvals.metadata IS 'Datos adicionales de la decisión en formato JSON';
COMMENT ON COLUMN approval.log_workflow_approvals.comments IS 'Comentarios del aprobador (obligatorios en rechazos)';

-- Índices para log_workflow_approvals
CREATE INDEX IF NOT EXISTS idx_log_workflow_approvals_entity_workflow ON approval.log_workflow_approvals(entity_workflow_id);
CREATE INDEX IF NOT EXISTS idx_log_workflow_approvals_stage ON approval.log_workflow_approvals(stage_id);
CREATE INDEX IF NOT EXISTS idx_log_workflow_approvals_approver ON approval.log_workflow_approvals(approver_id);
CREATE INDEX IF NOT EXISTS idx_log_workflow_approvals_decision ON approval.log_workflow_approvals(decision);
CREATE INDEX IF NOT EXISTS idx_log_workflow_approvals_decision_at ON approval.log_workflow_approvals(decision_at);

-- =====================================================
-- TABLA 5: Configuración de Notificaciones
-- =====================================================

CREATE TABLE IF NOT EXISTS approval.cfg_workflow_notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    workflow_id uuid NOT NULL,
    stage_id uuid,
    notification_type varchar(50) NOT NULL, -- 'assignment', 'reminder', 'escalation', 'completion'
    recipient_role varchar(100),
    template_subject text,
    template_body text,
    timing varchar(50) DEFAULT 'immediate', -- 'immediate', 'delayed', 'scheduled'
    delay_hours integer DEFAULT 0,
    channels jsonb DEFAULT '["email"]', -- ["email", "in_app", "slack", "discord"]
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_cfg_workflow_notifications_workflow FOREIGN KEY (workflow_id)
        REFERENCES approval.mst_workflows(id) ON DELETE CASCADE,
    CONSTRAINT fk_cfg_workflow_notifications_stage FOREIGN KEY (stage_id)
        REFERENCES approval.mst_workflow_stages(id) ON DELETE CASCADE,
    CONSTRAINT chk_cfg_workflow_notifications_type CHECK (notification_type IN ('assignment', 'reminder', 'escalation', 'completion')),
    CONSTRAINT chk_cfg_workflow_notifications_timing CHECK (timing IN ('immediate', 'delayed', 'scheduled'))
);

COMMENT ON TABLE approval.cfg_workflow_notifications IS 'Configuración de notificaciones por workflow y etapa';
COMMENT ON COLUMN approval.cfg_workflow_notifications.channels IS 'Canales de notificación disponibles';
COMMENT ON COLUMN approval.cfg_workflow_notifications.template_subject IS 'Asunto de la notificación';
COMMENT ON COLUMN approval.cfg_workflow_notifications.template_body IS 'Cuerpo de la notificación con variables dinámicas';

-- Índices para cfg_workflow_notifications
CREATE INDEX IF NOT EXISTS idx_cfg_workflow_notifications_workflow ON approval.cfg_workflow_notifications(workflow_id);
CREATE INDEX IF NOT EXISTS idx_cfg_workflow_notifications_stage ON approval.cfg_workflow_notifications(stage_id);
CREATE INDEX IF NOT EXISTS idx_cfg_workflow_notifications_type ON approval.cfg_workflow_notifications(notification_type);

-- =====================================================
-- EXTENSIONES A TABLAS EXISTENTES
-- =====================================================

-- Extensión a budgeting.trn_monthly_budgets para workflow
ALTER TABLE budgeting.trn_monthly_budgets
ADD COLUMN IF NOT EXISTS workflow_id uuid,
ADD COLUMN IF NOT EXISTS workflow_status varchar(50) DEFAULT 'not_assigned',
ADD COLUMN IF NOT EXISTS current_stage varchar(255),
ADD COLUMN IF NOT EXISTS workflow_assigned_at timestamptz,
ADD COLUMN IF NOT EXISTS workflow_completed_at timestamptz,
ADD COLUMN IF NOT EXISTS followup_activated boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS followup_activated_at timestamptz;

-- Extensión a projects.trn_projects para workflow
ALTER TABLE projects.trn_projects
ADD COLUMN IF NOT EXISTS workflow_id uuid,
ADD COLUMN IF NOT EXISTS workflow_status varchar(50) DEFAULT 'not_assigned',
ADD COLUMN IF NOT EXISTS current_stage varchar(255),
ADD COLUMN IF NOT EXISTS workflow_assigned_at timestamptz,
ADD COLUMN IF NOT EXISTS workflow_completed_at timestamptz,
ADD COLUMN IF NOT EXISTS critical_change_type varchar(100), -- 'status_change', 'budget_change', 'scope_change'
ADD COLUMN IF NOT EXISTS change_justification text,
ADD COLUMN IF NOT EXISTS change_requested_by uuid,
ADD COLUMN IF NOT EXISTS change_requested_at timestamptz;

-- Extensión a tasks.trn_tasks para workflow
ALTER TABLE tasks.trn_tasks
ADD COLUMN IF NOT EXISTS workflow_id uuid,
ADD COLUMN IF NOT EXISTS workflow_status varchar(50) DEFAULT 'not_assigned',
ADD COLUMN IF NOT EXISTS current_stage varchar(255),
ADD COLUMN IF NOT EXISTS workflow_assigned_at timestamptz,
ADD COLUMN IF NOT EXISTS workflow_completed_at timestamptz,
ADD COLUMN IF NOT EXISTS criticality_level varchar(20) DEFAULT 'normal', -- 'normal', 'high', 'critical'
ADD COLUMN IF NOT EXISTS assignment_change_type varchar(50), -- 'initial_assignment', 'reassignment'
ADD COLUMN IF NOT EXISTS assignment_justification text,
ADD COLUMN IF NOT EXISTS assignment_requested_by uuid,
ADD COLUMN IF NOT EXISTS assignment_requested_at timestamptz;

-- Comentarios en las nuevas columnas
-- Budgeting
COMMENT ON COLUMN budgeting.trn_monthly_budgets.workflow_id IS 'ID del workflow asignado al presupuesto';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.workflow_status IS 'Estado del workflow: not_assigned, pending, in_progress, approved, rejected';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.current_stage IS 'Etapa actual del workflow';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.workflow_assigned_at IS 'Fecha de asignación del workflow';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.workflow_completed_at IS 'Fecha de completado del workflow';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.followup_activated IS 'Indica si el seguimiento se activó automáticamente';
COMMENT ON COLUMN budgeting.trn_monthly_budgets.followup_activated_at IS 'Fecha de activación del seguimiento';

-- Projects
COMMENT ON COLUMN projects.trn_projects.workflow_id IS 'ID del workflow asignado al proyecto';
COMMENT ON COLUMN projects.trn_projects.workflow_status IS 'Estado del workflow: not_assigned, pending, in_progress, approved, rejected';
COMMENT ON COLUMN projects.trn_projects.current_stage IS 'Etapa actual del workflow';
COMMENT ON COLUMN projects.trn_projects.workflow_assigned_at IS 'Fecha de asignación del workflow';
COMMENT ON COLUMN projects.trn_projects.workflow_completed_at IS 'Fecha de completado del workflow';
COMMENT ON COLUMN projects.trn_projects.critical_change_type IS 'Tipo de cambio crítico: status_change, budget_change, scope_change';
COMMENT ON COLUMN projects.trn_projects.change_justification IS 'Justificación del cambio solicitado';
COMMENT ON COLUMN projects.trn_projects.change_requested_by IS 'Usuario que solicitó el cambio';
COMMENT ON COLUMN projects.trn_projects.change_requested_at IS 'Fecha de solicitud del cambio';

-- Tasks
COMMENT ON COLUMN tasks.trn_tasks.workflow_id IS 'ID del workflow asignado a la tarea';
COMMENT ON COLUMN tasks.trn_tasks.workflow_status IS 'Estado del workflow: not_assigned, pending, in_progress, approved, rejected';
COMMENT ON COLUMN tasks.trn_tasks.current_stage IS 'Etapa actual del workflow';
COMMENT ON COLUMN tasks.trn_tasks.workflow_assigned_at IS 'Fecha de asignación del workflow';
COMMENT ON COLUMN tasks.trn_tasks.workflow_completed_at IS 'Fecha de completado del workflow';
COMMENT ON COLUMN tasks.trn_tasks.criticality_level IS 'Nivel de criticidad: normal, high, critical';
COMMENT ON COLUMN tasks.trn_tasks.assignment_change_type IS 'Tipo de cambio de asignación: initial_assignment, reassignment';
COMMENT ON COLUMN tasks.trn_tasks.assignment_justification IS 'Justificación de la asignación/cambio';
COMMENT ON COLUMN tasks.trn_tasks.assignment_requested_by IS 'Usuario que solicitó la asignación/cambio';
COMMENT ON COLUMN tasks.trn_tasks.assignment_requested_at IS 'Fecha de solicitud de asignación/cambio';

-- Índices para las nuevas columnas
-- Budgeting
CREATE INDEX IF NOT EXISTS idx_monthly_budgets_workflow_status ON budgeting.trn_monthly_budgets(workflow_status);
CREATE INDEX IF NOT EXISTS idx_monthly_budgets_workflow_id ON budgeting.trn_monthly_budgets(workflow_id);

-- Projects
CREATE INDEX IF NOT EXISTS idx_projects_workflow_status ON projects.trn_projects(workflow_status);
CREATE INDEX IF NOT EXISTS idx_projects_workflow_id ON projects.trn_projects(workflow_id);
CREATE INDEX IF NOT EXISTS idx_projects_critical_change_type ON projects.trn_projects(critical_change_type);

-- Tasks
CREATE INDEX IF NOT EXISTS idx_tasks_workflow_status ON tasks.trn_tasks(workflow_status);
CREATE INDEX IF NOT EXISTS idx_tasks_workflow_id ON tasks.trn_tasks(workflow_id);
CREATE INDEX IF NOT EXISTS idx_tasks_criticality_level ON tasks.trn_tasks(criticality_level);
CREATE INDEX IF NOT EXISTS idx_tasks_assignment_change_type ON tasks.trn_tasks(assignment_change_type);

-- Foreign Key constraints para workflow_id
DO $$
BEGIN
    -- Budgeting
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_schema = 'budgeting'
                   AND table_name = 'trn_monthly_budgets'
                   AND constraint_name = 'fk_monthly_budgets_workflow_id') THEN
        ALTER TABLE budgeting.trn_monthly_budgets
        ADD CONSTRAINT fk_monthly_budgets_workflow_id
        FOREIGN KEY (workflow_id) REFERENCES approval.mst_workflows(id);
    END IF;

    -- Projects
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_schema = 'projects'
                   AND table_name = 'trn_projects'
                   AND constraint_name = 'fk_projects_workflow_id') THEN
        ALTER TABLE projects.trn_projects
        ADD CONSTRAINT fk_projects_workflow_id
        FOREIGN KEY (workflow_id) REFERENCES approval.mst_workflows(id);
    END IF;

    -- Tasks
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_schema = 'tasks'
                   AND table_name = 'trn_tasks'
                   AND constraint_name = 'fk_tasks_workflow_id') THEN
        ALTER TABLE tasks.trn_tasks
        ADD CONSTRAINT fk_tasks_workflow_id
        FOREIGN KEY (workflow_id) REFERENCES approval.mst_workflows(id);
    END IF;
END $$;

-- Extensión a budgeting.trn_resource_assignments para ingresos
ALTER TABLE budgeting.trn_resource_assignments
ADD COLUMN IF NOT EXISTS revenue_contribution numeric DEFAULT 0,
ADD COLUMN IF NOT EXISTS margin_contribution numeric DEFAULT 0;

-- Comentarios en las nuevas columnas
COMMENT ON COLUMN budgeting.trn_resource_assignments.revenue_contribution IS 'Contribución estimada a ingresos del empleado en la asignación';
COMMENT ON COLUMN budgeting.trn_resource_assignments.margin_contribution IS 'Contribución estimada a margen del empleado en la asignación';

-- =====================================================
-- FUNCIONES SQL INTELIGENTES
-- =====================================================

-- Función para asignar workflow automáticamente
CREATE OR REPLACE FUNCTION approval.assign_workflow(
    p_entity_type varchar,
    p_entity_id uuid,
    p_workflow_id uuid
) RETURNS uuid AS $$
DECLARE
    v_workflow_record record;
    v_first_stage record;
    v_entity_workflow_id uuid;
BEGIN
    -- Validar que el workflow existe y está activo
    SELECT * INTO v_workflow_record
    FROM approval.mst_workflows
    WHERE id = p_workflow_id AND is_active = true;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Workflow no encontrado o inactivo';
    END IF;

    -- Obtener primera etapa del workflow
    SELECT * INTO v_first_stage
    FROM approval.mst_workflow_stages
    WHERE workflow_id = p_workflow_id
    ORDER BY stage_order
    LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Workflow no tiene etapas definidas';
    END IF;

    -- Crear asignación de workflow
    INSERT INTO approval.trn_entity_workflows (
        entity_type, entity_id, workflow_id,
        status, current_stage_id, assigned_at
    ) VALUES (
        p_entity_type, p_entity_id, p_workflow_id,
        'in_progress', v_first_stage.id, CURRENT_TIMESTAMP
    ) RETURNING id INTO v_entity_workflow_id;

    -- Actualizar entidad específica si es presupuesto
    IF p_entity_type = 'budget' THEN
        UPDATE budgeting.trn_monthly_budgets
        SET workflow_id = p_workflow_id,
            workflow_status = 'in_progress',
            current_stage = v_first_stage.name,
            workflow_assigned_at = CURRENT_TIMESTAMP
        WHERE id = p_entity_id;
    END IF;

    RETURN v_entity_workflow_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION approval.assign_workflow(varchar, uuid, uuid) IS 'Asigna un workflow a una entidad y activa la primera etapa';

-- Función para procesar decisiones de aprobación
CREATE OR REPLACE FUNCTION approval.process_approval_decision(
    p_entity_workflow_id uuid,
    p_decision varchar,
    p_comments text DEFAULT NULL,
    p_approver_id uuid DEFAULT NULL
) RETURNS void AS $$
DECLARE
    v_entity_workflow record;
    v_current_stage record;
    v_next_stage record;
    v_workflow_complete boolean := false;
BEGIN
    -- Obtener información del workflow actual
    SELECT ew.*, ws.stage_order, ws.workflow_id
    INTO v_entity_workflow
    FROM approval.trn_entity_workflows ew
    JOIN approval.mst_workflow_stages ws ON ew.current_stage_id = ws.id
    WHERE ew.id = p_entity_workflow_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Entity workflow no encontrado';
    END IF;

    -- Registrar la decisión
    INSERT INTO approval.log_workflow_approvals (
        entity_workflow_id, stage_id, approver_id,
        decision, comments, decision_at
    ) VALUES (
        p_entity_workflow_id, v_entity_workflow.current_stage_id, p_approver_id,
        p_decision, p_comments, CURRENT_TIMESTAMP
    );

    -- Determinar siguiente acción basada en la decisión
    IF p_decision = 'approved' THEN
        -- Buscar siguiente etapa
        SELECT * INTO v_next_stage
        FROM approval.mst_workflow_stages
        WHERE workflow_id = v_entity_workflow.workflow_id
        AND stage_order > v_entity_workflow.stage_order
        ORDER BY stage_order
        LIMIT 1;

        IF FOUND THEN
            -- Avanzar a siguiente etapa
            UPDATE approval.trn_entity_workflows
            SET current_stage_id = v_next_stage.id,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = p_entity_workflow_id;

            -- Actualizar entidad específica
            IF v_entity_workflow.entity_type = 'budget' THEN
                UPDATE budgeting.trn_monthly_budgets
                SET current_stage = v_next_stage.name,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = v_entity_workflow.entity_id;
            END IF;
        ELSE
            -- Workflow completado
            UPDATE approval.trn_entity_workflows
            SET status = 'approved',
                completed_at = CURRENT_TIMESTAMP,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = p_entity_workflow_id;

            -- Marcar workflow como completado en entidad específica
            IF v_entity_workflow.entity_type = 'budget' THEN
                UPDATE budgeting.trn_monthly_budgets
                SET workflow_status = 'approved',
                    workflow_completed_at = CURRENT_TIMESTAMP,
                    followup_activated = true,
                    followup_activated_at = CURRENT_TIMESTAMP,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = v_entity_workflow.entity_id;
            END IF;

            v_workflow_complete := true;
        END IF;

    ELSIF p_decision = 'rejected' THEN
        -- Buscar etapa anterior
        SELECT * INTO v_next_stage
        FROM approval.mst_workflow_stages
        WHERE workflow_id = v_entity_workflow.workflow_id
        AND stage_order < v_entity_workflow.stage_order
        ORDER BY stage_order DESC
        LIMIT 1;

        IF FOUND THEN
            -- Retroceder a etapa anterior
            UPDATE approval.trn_entity_workflows
            SET current_stage_id = v_next_stage.id,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = p_entity_workflow_id;

            -- Actualizar entidad específica
            IF v_entity_workflow.entity_type = 'budget' THEN
                UPDATE budgeting.trn_monthly_budgets
                SET current_stage = v_next_stage.name,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = v_entity_workflow.entity_id;
            END IF;
        ELSE
            -- Rechazo final - marcar como rechazado
            UPDATE approval.trn_entity_workflows
            SET status = 'rejected',
                completed_at = CURRENT_TIMESTAMP,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = p_entity_workflow_id;

            -- Marcar como rechazado en entidad específica
            IF v_entity_workflow.entity_type = 'budget' THEN
                UPDATE budgeting.trn_monthly_budgets
                SET workflow_status = 'rejected',
                    workflow_completed_at = CURRENT_TIMESTAMP,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = v_entity_workflow.entity_id;
            END IF;
        END IF;
    END IF;

    -- Aquí se podrían agregar triggers para notificaciones automáticas
    -- y otras acciones post-decisión

END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION approval.process_approval_decision(uuid, varchar, text, uuid) IS 'Procesa una decisión de aprobación y actualiza el estado del workflow';

-- Función para obtener aprobaciones pendientes de un usuario
CREATE OR REPLACE FUNCTION approval.get_pending_approvals(p_user_id uuid)
RETURNS TABLE (
    entity_workflow_id uuid,
    entity_type varchar,
    entity_id uuid,
    workflow_name varchar,
    stage_name varchar,
    assigned_at timestamptz,
    timeout_hours integer
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ew.id,
        ew.entity_type,
        ew.entity_id,
        mw.name,
        ws.name,
        ew.assigned_at,
        ws.timeout_hours
    FROM approval.trn_entity_workflows ew
    JOIN approval.mst_workflow_stages ws ON ew.current_stage_id = ws.id
    JOIN approval.mst_workflows mw ON ew.workflow_id = mw.id
    JOIN base.rel_user_role_entities ur ON ws.required_role = ur.role_name
    WHERE ew.status = 'in_progress'
    AND ur.user_id = p_user_id
    AND ur.is_active = true
    ORDER BY ew.assigned_at;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION approval.get_pending_approvals(uuid) IS 'Obtiene las aprobaciones pendientes para un usuario específico';

-- =====================================================
-- DATOS DE EJEMPLO PARA TESTING
-- =====================================================

-- Insertar workflows maestros de ejemplo
-- Presupuestos
INSERT INTO approval.mst_workflows (name, description, icon, entity_type, created_by, updated_by)
VALUES (
    'Aprobación Presupuestos',
    'Workflow estándar para aprobación de presupuestos mensuales',
    'budget-check',
    'budget',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
) ON CONFLICT (name, entity_type) DO NOTHING;

-- Proyectos
INSERT INTO approval.mst_workflows (name, description, icon, entity_type, created_by, updated_by)
VALUES (
    'Cambio Estado Proyecto',
    'Workflow para cambios críticos de estado en proyectos',
    'project-status',
    'project',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
) ON CONFLICT (name, entity_type) DO NOTHING;

-- Tareas
INSERT INTO approval.mst_workflows (name, description, icon, entity_type, created_by, updated_by)
VALUES (
    'Asignación Tarea Crítica',
    'Workflow para asignación de tareas críticas y reasignaciones',
    'task-critical',
    'task',
    (SELECT id FROM base.mst_users LIMIT 1),
    (SELECT id FROM base.mst_users LIMIT 1)
) ON CONFLICT (name, entity_type) DO NOTHING;

-- Insertar etapas del workflow de ejemplo
INSERT INTO approval.mst_workflow_stages (workflow_id, stage_order, name, description, required_role, approval_type, timeout_hours)
SELECT
    mw.id,
    1,
    'Revisión CTO',
    'Revisión técnica y validación por Chief Technology Officer',
    'cto',
    'single',
    48
FROM approval.mst_workflows mw
WHERE mw.name = 'Aprobación Presupuestos' AND mw.entity_type = 'budget'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (workflow_id, stage_order, name, description, required_role, approval_type, timeout_hours)
SELECT
    mw.id,
    2,
    'Aprobación Ejecutiva',
    'Aprobación final por equipo directivo',
    'executive',
    'quorum',
    72
FROM approval.mst_workflows mw
WHERE mw.name = 'Aprobación Presupuestos' AND mw.entity_type = 'budget'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para workflow de proyectos
INSERT INTO approval.mst_workflow_stages (workflow_id, stage_order, name, description, required_role, approval_type, timeout_hours)
SELECT
    mw.id,
    1,
    'Aprobación Supervisor',
    'Aprobación por supervisor del proyecto',
    'project_supervisor',
    'single',
    24
FROM approval.mst_workflows mw
WHERE mw.name = 'Cambio Estado Proyecto' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (workflow_id, stage_order, name, description, required_role, approval_type, timeout_hours)
SELECT
    mw.id,
    2,
    'Aprobación CTO',
    'Aprobación técnica por Chief Technology Officer',
    'cto',
    'single',
    48
FROM approval.mst_workflows mw
WHERE mw.name = 'Cambio Estado Proyecto' AND mw.entity_type = 'project'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Etapas para workflow de tareas
INSERT INTO approval.mst_workflow_stages (workflow_id, stage_order, name, description, required_role, approval_type, timeout_hours)
SELECT
    mw.id,
    1,
    'Aprobación Supervisor Técnico',
    'Aprobación por supervisor técnico según skills requeridos',
    'technical_supervisor',
    'single',
    12
FROM approval.mst_workflows mw
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

INSERT INTO approval.mst_workflow_stages (workflow_id, stage_order, name, description, required_role, approval_type, timeout_hours)
SELECT
    mw.id,
    2,
    'Aprobación Project Manager',
    'Aprobación final por Project Manager',
    'project_manager',
    'single',
    24
FROM approval.mst_workflows mw
WHERE mw.name = 'Asignación Tarea Crítica' AND mw.entity_type = 'task'
ON CONFLICT (workflow_id, stage_order) DO NOTHING;

-- Insertar configuración de notificaciones de ejemplo
INSERT INTO approval.cfg_workflow_notifications (workflow_id, stage_id, notification_type, recipient_role, template_subject, template_body)
SELECT
    mw.id,
    ws.id,
    'assignment',
    ws.required_role,
    'Nueva solicitud de aprobación pendiente',
    'Tienes una nueva solicitud pendiente de aprobación en el sistema.'
FROM approval.mst_workflows mw
JOIN approval.mst_workflow_stages ws ON mw.id = ws.workflow_id
WHERE mw.name = 'Aprobación Presupuestos' AND mw.entity_type = 'budget'
ON CONFLICT DO NOTHING;

COMMIT;
