-- EP-008: Categorización Básica de Pausas
-- Fecha: 2025-09-16
-- Descripción: Solo categorización básica de pausas

-- ===========================================
-- EXTENSIONES BÁSICAS PARA CATEGORIZACIÓN
-- ===========================================

-- Extender trn_time_breaks con campo de categoría básica - EP-008-US-003
ALTER TABLE time_tracking.trn_time_breaks
ADD COLUMN IF NOT EXISTS break_category text DEFAULT 'rest'
CHECK (break_category IN ('lunch', 'rest', 'meeting', 'emergency', 'personal'));

-- Extender con campo de descripción opcional - EP-008-US-003
ALTER TABLE time_tracking.trn_time_breaks
ADD COLUMN IF NOT EXISTS break_notes text;

-- ===========================================
-- ÍNDICES BÁSICOS
-- ===========================================

CREATE INDEX IF NOT EXISTS idx_trn_time_breaks_category ON time_tracking.trn_time_breaks(break_category);

-- ===========================================
-- FUNCIÓN BÁSICA PARA ESTADÍSTICAS
-- ===========================================

CREATE OR REPLACE FUNCTION time_tracking.get_break_stats(user_id_param uuid DEFAULT NULL, start_date date DEFAULT (CURRENT_DATE - INTERVAL '30 days'), end_date date DEFAULT CURRENT_DATE)
RETURNS jsonb AS $$
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
        FROM time_tracking.trn_time_breaks b
        JOIN time_tracking.trn_time_entries e ON b.time_entry_id = e.id
        WHERE (user_id_param IS NULL OR e.user_id = user_id_param)
        AND e.entry_date BETWEEN start_date AND end_date
        GROUP BY break_category, duration_minutes
    ) stats;

    RETURN COALESCE(result, jsonb_build_object(
        'total_breaks', 0,
        'by_category', '{}'::jsonb,
        'avg_duration', 0,
        'total_duration', 0
    ));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===========================================
-- DATOS INICIALES BÁSICOS
-- ===========================================

-- Actualizar categorías existentes basadas en break_type
UPDATE time_tracking.trn_time_breaks
SET break_category = CASE
    WHEN break_type = 'lunch' THEN 'lunch'
    WHEN break_type = 'meeting' THEN 'meeting'
    WHEN break_type = 'emergency' THEN 'emergency'
    WHEN break_type = 'rest' THEN 'rest'
    ELSE 'personal'
END
WHERE break_category IS NULL;

-- ===========================================
-- COMENTARIOS
-- ===========================================

COMMENT ON COLUMN time_tracking.trn_time_breaks.break_category IS 'EP-008-US-003: Categoría básica de la pausa: lunch, rest, meeting, emergency, personal';
COMMENT ON COLUMN time_tracking.trn_time_breaks.break_notes IS 'EP-008-US-003: Notas opcionales sobre la pausa para mejor tracking';
COMMENT ON FUNCTION time_tracking.get_break_stats(uuid, date, date) IS 'EP-008-US-004: Estadísticas básicas de pausas por categoría para reportes';

COMMIT;
