
-- Script completo para unificar tablas de time_tracking

-- ===========================================
-- 1. CREAR NUEVA TABLA UNIFICADA
-- ===========================================

CREATE TABLE time_tracking.trn_time_records (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Campos comunes a todos los tipos
    user_id uuid NOT NULL,
    project_id uuid,
    task_id uuid,
    entry_date date NOT NULL,
    entry_type text NOT NULL CHECK (entry_type IN ('WORK_ENTRY', 'BREAK', 'APPROVAL')),
    
    -- Campos para WORK_ENTRY
    start_time time,
    end_time time,
    hours_worked numeric,
    description text,
    is_billable boolean DEFAULT true,
    status text DEFAULT 'DRAFT',
    
    -- Campos para BREAK (cuando entry_type = 'BREAK')
    break_type text,
    break_category text DEFAULT 'rest',
    duration_minutes integer,
    break_notes text,
    
    -- Campos para APPROVAL (cuando entry_type = 'APPROVAL')
    approval_action text,
    approval_comments text,
    approved_at timestamp with time zone,
    
    -- Campos de auditoría
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL,
    updated_by uuid NOT NULL,
    
    -- Foreign Keys
    FOREIGN KEY (user_id) REFERENCES base.mst_users(id),
    FOREIGN KEY (project_id) REFERENCES projects.trn_projects(id),
    FOREIGN KEY (task_id) REFERENCES tasks.trn_tasks(id)
);

-- ===========================================
-- 2. CREAR ÍNDICES OPTIMIZADOS
-- ===========================================

CREATE INDEX idx_trn_time_records_user_date ON time_tracking.trn_time_records(user_id, entry_date);
CREATE INDEX idx_trn_time_records_project ON time_tracking.trn_time_records(project_id);
CREATE INDEX idx_trn_time_records_task ON time_tracking.trn_time_records(task_id);
CREATE INDEX idx_trn_time_records_type ON time_tracking.trn_time_records(entry_type);
CREATE INDEX idx_trn_time_records_status ON time_tracking.trn_time_records(status);
CREATE INDEX idx_trn_time_records_break_category ON time_tracking.trn_time_records(break_category) WHERE entry_type = 'BREAK';

-- ===========================================
-- 3. MIGRAR DATOS EXISTENTES
-- ===========================================

-- Migrar time entries
INSERT INTO time_tracking.trn_time_records (
    id, user_id, project_id, task_id, entry_date, entry_type,
    start_time, end_time, hours_worked, description, is_billable, status,
    created_at, updated_at, created_by, updated_by
)
SELECT 
    id, user_id, project_id, task_id, entry_date, 'WORK_ENTRY',
    start_time, end_time, hours_worked, description, is_billable, status,
    created_at, updated_at, created_by, updated_by
FROM time_tracking.trn_time_entries;

-- Migrar breaks
INSERT INTO time_tracking.trn_time_records (
    id, user_id, project_id, task_id, entry_date, entry_type,
    break_type, break_category, duration_minutes, description, break_notes,
    created_at, updated_at, created_by, updated_by
)
SELECT 
    tb.id, te.user_id, te.project_id, te.task_id, te.entry_date, 'BREAK',
    tb.break_type, tb.break_category, tb.duration_minutes, tb.description, tb.break_notes,
    tb.created_at, tb.updated_at, tb.created_by, tb.updated_by
FROM time_tracking.trn_time_breaks tb
JOIN time_tracking.trn_time_entries te ON tb.time_entry_id = te.id;

-- Migrar approvals
INSERT INTO time_tracking.trn_time_records (
    id, user_id, project_id, task_id, entry_date, entry_type,
    approval_action, approval_comments, approved_at,
    created_at, updated_at, created_by, updated_by
)
SELECT 
    ta.id, te.user_id, te.project_id, te.task_id, te.entry_date, 'APPROVAL',
    ta.action, ta.comments, ta.approved_at,
    ta.created_at, ta.updated_at, ta.created_by, ta.updated_by
FROM time_tracking.trn_time_approvals ta
JOIN time_tracking.trn_time_entries te ON ta.time_entry_id = te.id;

-- ===========================================
-- 4. CREAR FUNCIÓN ACTUALIZADA
-- ===========================================

CREATE OR REPLACE FUNCTION time_tracking.get_break_stats(user_id_param uuid DEFAULT NULL, start_date date DEFAULT (CURRENT_DATE - INTERVAL '30 days'), end_date date DEFAULT CURRENT_DATE)
RETURNS jsonb AS \$\$
DECLARE
    result jsonb;
BEGIN
    SELECT jsonb_build_object(
        'total_breaks', COUNT(*),
        'by_category', COALESCE(jsonb_object_agg(break_category, category_count), '{}'::jsonb),
        'avg_duration', COALESCE(AVG(duration_minutes), 0),
        'total_duration', COALESCE(SUM(duration_minutes), 0)
    ) INTO result
    FROM (
        SELECT break_category,
               COUNT(*) as category_count,
               duration_minutes
        FROM time_tracking.trn_time_records
        WHERE entry_type = 'BREAK'
        AND (user_id_param IS NULL OR user_id = user_id_param)
        AND entry_date BETWEEN start_date AND end_date
        GROUP BY break_category, duration_minutes
    ) stats;

    RETURN COALESCE(result, jsonb_build_object(
        'total_breaks', 0,
        'by_category', '{}'::jsonb,
        'avg_duration', 0,
        'total_duration', 0
    ));
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===========================================
-- 5. ELIMINAR TABLAS ANTIGUAS
-- ===========================================

DROP TABLE IF EXISTS time_tracking.trn_time_approvals;
DROP TABLE IF EXISTS time_tracking.trn_time_breaks;
DROP TABLE IF EXISTS time_tracking.trn_time_entries;

-- ===========================================
-- 6. COMENTARIOS
-- ===========================================

COMMENT ON TABLE time_tracking.trn_time_records IS 'EP-008: Tabla unificada para registros de tiempo (trabajo, pausas, aprobaciones)';
COMMENT ON COLUMN time_tracking.trn_time_records.entry_type IS 'Tipo de registro: WORK_ENTRY, BREAK, APPROVAL';
COMMENT ON COLUMN time_tracking.trn_time_records.break_category IS 'EP-008: Categoría de pausa (lunch, rest, meeting, emergency, personal)';
COMMENT ON FUNCTION time_tracking.get_break_stats(uuid, date, date) IS 'EP-008: Estadísticas de pausas por categoría en tabla unificada';

-- ===========================================
-- 7. VERIFICACIÓN FINAL
-- ===========================================

SELECT 
    'Migración completada:' as status,
    entry_type,
    COUNT(*) as records_count,
    COUNT(DISTINCT user_id) as users_count,
    COUNT(DISTINCT project_id) as projects_count
FROM time_tracking.trn_time_records
GROUP BY entry_type
ORDER BY entry_type;

COMMIT;
