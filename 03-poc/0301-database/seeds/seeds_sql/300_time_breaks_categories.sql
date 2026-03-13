
-- Actualizar seed para nueva ubicación en esquema tasks
-- Verificar tabla existe y tiene columnas requeridas
DO \$\$
DECLARE
    table_exists BOOLEAN;
    category_exists BOOLEAN;
    notes_exists BOOLEAN;
BEGIN
    -- Verificar que la tabla existe en el nuevo esquema
    SELECT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'tasks' 
        AND table_name = 'trn_task_time_records'
    ) INTO table_exists;

    IF NOT table_exists THEN
        RAISE EXCEPTION 'Required table tasks.trn_task_time_records does not exist';
    END IF;

    -- Verificar columnas requeridas
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'tasks'
        AND table_name = 'trn_task_time_records'
        AND column_name = 'break_category'
    ) INTO category_exists;

    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'tasks'
        AND table_name = 'trn_task_time_records'
        AND column_name = 'break_notes'
    ) INTO notes_exists;

    IF NOT category_exists OR NOT notes_exists THEN
        RAISE EXCEPTION 'Required columns break_category or break_notes do not exist in tasks.trn_task_time_records';
    END IF;

    RAISE NOTICE 'All required dependencies verified for tasks.trn_task_time_records seed';
END \$\$;

-- Actualizar categorías basadas en break_type existente - EP-008-US-003
UPDATE tasks.trn_task_time_records
SET break_category = CASE
    WHEN break_type = 'lunch' THEN 'lunch'
    WHEN break_type = 'meeting' THEN 'meeting'
    WHEN break_type = 'emergency' THEN 'emergency'
    WHEN break_type = 'rest' THEN 'rest'
    ELSE 'rest'
END
WHERE entry_type = 'BREAK' 
AND break_category IS NULL OR break_category = 'rest';

-- Agregar algunas notas de ejemplo a breaks existentes - EP-008-US-003
UPDATE tasks.trn_task_time_records
SET break_notes = CASE
    WHEN break_type = 'lunch' AND duration_minutes > 60 THEN 'Extended lunch due to meeting'
    WHEN break_type = 'meeting' AND duration_minutes > 120 THEN 'Extended meeting'
    WHEN break_type = 'emergency' AND duration_minutes < 30 THEN 'Brief emergency'
    WHEN break_type = 'rest' AND duration_minutes > 45 THEN 'Extended rest due to workload'
    ELSE NULL
END
WHERE entry_type = 'BREAK'
AND break_notes IS NULL
AND id IN (
    SELECT id FROM tasks.trn_task_time_records
    WHERE entry_type = 'BREAK'
    ORDER BY created_at DESC
    LIMIT 20
);

-- Verificar resultados
SELECT 
    'EP-008 Categorization completed:' as status,
    COUNT(*) FILTER (WHERE entry_type = 'WORK_ENTRY') as work_entries,
    COUNT(*) FILTER (WHERE entry_type = 'BREAK') as breaks_total,
    COUNT(*) FILTER (WHERE entry_type = 'BREAK' AND break_category IS NOT NULL) as categorized_breaks,
    COUNT(*) FILTER (WHERE entry_type = 'BREAK' AND break_notes IS NOT NULL) as breaks_with_notes
FROM tasks.trn_task_time_records;
