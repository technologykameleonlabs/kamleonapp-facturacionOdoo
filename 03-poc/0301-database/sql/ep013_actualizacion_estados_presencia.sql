-- =============================================================================
-- EP-013: ACTUALIZACIÓN DE ESTADOS DE PRESENCIA
-- =============================================================================
-- Propósito: Sistema completo de gestión de estados de presencia
-- Funcionalidad: Estados manuales, automáticos, temporales y notificaciones
-- =============================================================================

-- =====================================================
-- ESQUEMA Y TABLAS DEL SISTEMA
-- =====================================================

CREATE SCHEMA IF NOT EXISTS presence;
COMMENT ON SCHEMA presence IS 'Sistema de gestión de estados de presencia de usuarios';

-- =====================================================
-- 1. ESTADOS MAESTROS DE PRESENCIA
-- =====================================================

CREATE TABLE IF NOT EXISTS presence.mst_presence_states (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code varchar(50) NOT NULL UNIQUE,
    name varchar(100) NOT NULL,
    description text,
    category varchar(20) DEFAULT 'available', -- 'available', 'busy', 'away', 'unavailable'
    color varchar(7) DEFAULT '#28a745', -- Hex color
    icon varchar(100), -- Emoji or icon name
    requires_justification boolean DEFAULT false,
    is_temporary_allowed boolean DEFAULT false,
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    CONSTRAINT chk_mst_presence_states_category CHECK (category IN ('available', 'busy', 'away', 'unavailable')),
    CONSTRAINT chk_mst_presence_states_color CHECK (color ~ '^#[0-9A-Fa-f]{6}$')
);

COMMENT ON TABLE presence.mst_presence_states IS 'Catálogo maestro de estados de presencia disponibles';
COMMENT ON COLUMN presence.mst_presence_states.code IS 'Código único del estado (conectado, trabajando, en_reunion, etc.)';
COMMENT ON COLUMN presence.mst_presence_states.category IS 'Categoría general del estado para agrupación';
COMMENT ON COLUMN presence.mst_presence_states.requires_justification IS 'Si el estado requiere justificación obligatoria';

-- =====================================================
-- 2. ESTADO ACTUAL DE PRESENCIA POR USUARIO
-- =====================================================

CREATE TABLE IF NOT EXISTS presence.trn_user_presence (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    current_state_id uuid NOT NULL,
    set_at timestamptz DEFAULT now(),
    expires_at timestamptz, -- Para estados temporales
    is_temporary boolean DEFAULT false,
    justification text,
    last_activity_at timestamptz, -- Para estados automáticos
    last_notification_sent timestamptz,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    CONSTRAINT fk_trn_user_presence_user FOREIGN KEY (user_id)
        REFERENCES base.mst_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_trn_user_presence_state FOREIGN KEY (current_state_id)
        REFERENCES presence.mst_presence_states(id),
    CONSTRAINT uk_trn_user_presence_user UNIQUE (user_id),
    CONSTRAINT chk_trn_user_presence_expires CHECK (
        (is_temporary = true AND expires_at IS NOT NULL) OR
        (is_temporary = false AND expires_at IS NULL)
    )
);

COMMENT ON TABLE presence.trn_user_presence IS 'Estado de presencia actual de cada usuario';
COMMENT ON COLUMN presence.trn_user_presence.set_at IS 'Cuándo se estableció el estado actual';
COMMENT ON COLUMN presence.trn_user_presence.expires_at IS 'Fecha de expiración para estados temporales';
COMMENT ON COLUMN presence.trn_user_presence.last_activity_at IS 'Última actividad detectada para estados automáticos';

-- =====================================================
-- 3. HISTORIAL COMPLETO DE CAMBIOS
-- =====================================================

CREATE TABLE IF NOT EXISTS presence.log_presence_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    from_state_id uuid,
    to_state_id uuid NOT NULL,
    changed_at timestamptz DEFAULT now(),
    change_source varchar(20) DEFAULT 'manual', -- 'manual', 'automatic', 'system'
    reason text, -- Justificación o motivo del cambio
    metadata jsonb DEFAULT '{}'::jsonb, -- Información adicional del cambio
    created_at timestamptz DEFAULT now(),

    CONSTRAINT fk_log_presence_history_user FOREIGN KEY (user_id)
        REFERENCES base.mst_users(id) ON DELETE CASCADE,
    CONSTRAINT fk_log_presence_history_from_state FOREIGN KEY (from_state_id)
        REFERENCES presence.mst_presence_states(id),
    CONSTRAINT fk_log_presence_history_to_state FOREIGN KEY (to_state_id)
        REFERENCES presence.mst_presence_states(id),
    CONSTRAINT chk_log_presence_history_source CHECK (change_source IN ('manual', 'automatic', 'system'))
);

COMMENT ON TABLE presence.log_presence_history IS 'Historial completo de todos los cambios de estado de presencia';
COMMENT ON COLUMN presence.log_presence_history.change_source IS 'Origen del cambio: manual (usuario), automatic (sistema), system (procesos)';
COMMENT ON COLUMN presence.log_presence_history.metadata IS 'Información adicional como IP, user agent, contexto del cambio';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_mst_presence_states_code ON presence.mst_presence_states(code);
CREATE INDEX IF NOT EXISTS idx_mst_presence_states_category ON presence.mst_presence_states(category);
CREATE INDEX IF NOT EXISTS idx_mst_presence_states_active ON presence.mst_presence_states(is_active);

CREATE INDEX IF NOT EXISTS idx_trn_user_presence_user ON presence.trn_user_presence(user_id);
CREATE INDEX IF NOT EXISTS idx_trn_user_presence_state ON presence.trn_user_presence(current_state_id);
CREATE INDEX IF NOT EXISTS idx_trn_user_presence_expires ON presence.trn_user_presence(expires_at) WHERE expires_at IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_trn_user_presence_temporary ON presence.trn_user_presence(is_temporary) WHERE is_temporary = true;

CREATE INDEX IF NOT EXISTS idx_log_presence_history_user ON presence.log_presence_history(user_id);
CREATE INDEX IF NOT EXISTS idx_log_presence_history_changed_at ON presence.log_presence_history(changed_at);
CREATE INDEX IF NOT EXISTS idx_log_presence_history_source ON presence.log_presence_history(change_source);

-- =====================================================
-- FUNCIONES DEL SISTEMA DE PRESENCIA
-- =====================================================

-- Función principal para cambiar estado de presencia
CREATE OR REPLACE FUNCTION presence.change_user_presence(
    p_user_id uuid,
    p_state_code varchar,
    p_justification text DEFAULT NULL,
    p_is_temporary boolean DEFAULT false,
    p_expires_at timestamptz DEFAULT NULL,
    p_change_source varchar DEFAULT 'manual'
)
RETURNS uuid AS $$
DECLARE
    v_current_presence record;
    v_new_state_id uuid;
    v_new_state record;
    v_presence_id uuid;
    v_notification_context jsonb;
BEGIN
    -- Validar que el estado existe y está activo
    SELECT id, name, category, requires_justification
    INTO v_new_state_id, v_new_state.name, v_new_state.category, v_new_state.requires_justification
    FROM presence.mst_presence_states
    WHERE code = p_state_code AND is_active = true;

    IF v_new_state_id IS NULL THEN
        RAISE EXCEPTION 'Estado de presencia no encontrado o inactivo: %', p_state_code;
    END IF;

    -- Validar justificación si es requerida
    IF v_new_state.requires_justification AND (p_justification IS NULL OR trim(p_justification) = '') THEN
        RAISE EXCEPTION 'Este estado requiere una justificación obligatoria';
    END IF;

    -- Obtener estado actual
    SELECT * INTO v_current_presence
    FROM presence.trn_user_presence
    WHERE user_id = p_user_id;

    -- Actualizar o crear registro de presencia
    INSERT INTO presence.trn_user_presence (
        user_id, current_state_id, set_at, expires_at, is_temporary, justification
    ) VALUES (
        p_user_id, v_new_state_id, now(), p_expires_at, p_is_temporary, p_justification
    )
    ON CONFLICT (user_id) DO UPDATE SET
        current_state_id = EXCLUDED.current_state_id,
        set_at = EXCLUDED.set_at,
        expires_at = EXCLUDED.expires_at,
        is_temporary = EXCLUDED.is_temporary,
        justification = EXCLUDED.justification,
        updated_at = now()
    RETURNING id INTO v_presence_id;

    -- Registrar en historial
    INSERT INTO presence.log_presence_history (
        user_id, from_state_id, to_state_id, changed_at, change_source, reason, metadata
    ) VALUES (
        p_user_id,
        v_current_presence.current_state_id,
        v_new_state_id,
        now(),
        p_change_source,
        p_justification,
        jsonb_build_object(
            'is_temporary', p_is_temporary,
            'expires_at', p_expires_at,
            'old_state_name', COALESCE(
                (SELECT name FROM presence.mst_presence_states WHERE id = v_current_presence.current_state_id),
                'Sin estado'
            ),
            'new_state_name', v_new_state.name
        )
    );

    -- Nota: Las notificaciones se implementarán cuando el sistema de notificaciones esté completo
    -- Por ahora, los cambios se registran en el historial y se pueden consultar desde la aplicación

    RETURN v_presence_id;
END;
$$ LANGUAGE plpgsql;

-- Función para actualizar actividad del usuario (para estados automáticos)
CREATE OR REPLACE FUNCTION presence.update_user_activity(p_user_id uuid)
RETURNS void AS $$
BEGIN
    UPDATE presence.trn_user_presence
    SET last_activity_at = now(), updated_at = now()
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- Función para procesar expiración de estados temporales
CREATE OR REPLACE FUNCTION presence.process_expired_temporary_states()
RETURNS integer AS $$
DECLARE
    v_expired_record record;
    v_processed_count integer := 0;
BEGIN
    FOR v_expired_record IN
        SELECT * FROM presence.trn_user_presence
        WHERE is_temporary = true
          AND expires_at <= now()
          AND expires_at IS NOT NULL
    LOOP
        -- Cambiar a estado por defecto (Conectado)
        PERFORM presence.change_user_presence(
            v_expired_record.user_id,
            'conectado',
            'Estado temporal expirado automáticamente',
            false,
            NULL,
            'system'
        );

        v_processed_count := v_processed_count + 1;
    END LOOP;

    RETURN v_processed_count;
END;
$$ LANGUAGE plpgsql;

-- Función para detectar inactividad y cambiar estado automáticamente
CREATE OR REPLACE FUNCTION presence.check_user_inactivity(p_inactivity_minutes integer DEFAULT 30)
RETURNS integer AS $$
DECLARE
    v_inactive_user record;
    v_changed_count integer := 0;
BEGIN
    FOR v_inactive_user IN
        SELECT up.*, u.name || ' ' || COALESCE(u.surname, '') as full_name
        FROM presence.trn_user_presence up
        JOIN base.mst_users u ON up.user_id = u.id
        JOIN presence.mst_presence_states ps ON up.current_state_id = ps.id
        WHERE ps.category IN ('available', 'busy')
          AND up.last_activity_at < now() - interval '1 minute' * p_inactivity_minutes
          AND up.is_temporary = false
    LOOP
        -- Cambiar a "Ausente" por inactividad
        PERFORM presence.change_user_presence(
            v_inactive_user.user_id,
            'ausente',
            format('Usuario inactivo por más de %s minutos', p_inactivity_minutes),
            false,
            NULL,
            'automatic'
        );

        v_changed_count := v_changed_count + 1;
    END LOOP;

    RETURN v_changed_count;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estado actual de un usuario
CREATE OR REPLACE FUNCTION presence.get_user_presence(p_user_id uuid)
RETURNS TABLE(
    user_id uuid,
    state_code varchar,
    state_name varchar,
    category varchar,
    color varchar,
    icon varchar,
    set_at timestamptz,
    expires_at timestamptz,
    is_temporary boolean,
    justification text,
    last_activity_at timestamptz
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        up.user_id,
        ps.code,
        ps.name,
        ps.category,
        ps.color,
        ps.icon,
        up.set_at,
        up.expires_at,
        up.is_temporary,
        up.justification,
        up.last_activity_at
    FROM presence.trn_user_presence up
    JOIN presence.mst_presence_states ps ON up.current_state_id = ps.id
    WHERE up.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener resumen de presencia por equipo
CREATE OR REPLACE FUNCTION presence.get_team_presence_summary(p_team_id uuid DEFAULT NULL)
RETURNS TABLE(
    state_code varchar,
    state_name varchar,
    user_count bigint,
    color varchar,
    icon varchar
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ps.code,
        ps.name,
        COUNT(*) as user_count,
        ps.color,
        ps.icon
    FROM presence.trn_user_presence up
    JOIN presence.mst_presence_states ps ON up.current_state_id = ps.id
    JOIN base.mst_users u ON up.user_id = u.id
    WHERE (p_team_id IS NULL OR u.team_id = p_team_id)
    GROUP BY ps.code, ps.name, ps.color, ps.icon, ps.sort_order
    ORDER BY ps.sort_order;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- DATOS DE EJEMPLO PARA PRESENCIA
-- =====================================================

-- Estados básicos de presencia
INSERT INTO presence.mst_presence_states (code, name, description, category, color, icon, requires_justification, is_temporary_allowed, sort_order)
VALUES
('conectado', 'Conectado', 'Usuario activo y disponible', 'available', '#28a745', '🟢', false, false, 1),
('trabajando', 'Trabajando', 'Enfocado en tareas de trabajo', 'busy', '#ffc107', '💼', false, false, 2),
('en_reunion', 'En reunión', 'Participando en reunión', 'busy', '#dc3545', '📅', false, true, 3),
('en_formacion', 'En formación', 'Asistiendo a capacitación', 'busy', '#6f42c1', '📚', false, true, 4),
('en_pausa', 'En pausa', 'Pausa corta', 'away', '#fd7e14', '☕', false, true, 5),
('ausente', 'Ausente', 'No disponible temporalmente', 'away', '#6c757d', '⚫', false, false, 6),
('enfermo', 'Enfermo', 'Ausente por enfermedad', 'unavailable', '#dc3545', '🤒', true, false, 7),
('vacaciones', 'De vacaciones', 'Ausente por vacaciones', 'unavailable', '#17a2b8', '🏖️', true, false, 8),
('fuera_oficina', 'Fuera de oficina', 'Trabajando remotamente', 'available', '#20c997', '🏠', false, false, 9)
ON CONFLICT (code) DO NOTHING;

-- =====================================================
-- INTEGRACIÓN CON SISTEMA DE NOTIFICACIONES
-- =====================================================
-- Nota: La integración completa se hará cuando el sistema de notificaciones esté completamente implementado
-- Por ahora, las funciones de presencia registran los cambios pero las notificaciones se pueden agregar después

-- =====================================================
-- FUNCIONES DE MANTENIMIENTO
-- =====================================================

-- Función para limpiar historial antiguo
CREATE OR REPLACE FUNCTION presence.cleanup_old_history(p_days integer DEFAULT 365)
RETURNS integer AS $$
DECLARE
    v_deleted_count integer;
BEGIN
    DELETE FROM presence.log_presence_history
    WHERE changed_at < now() - interval '1 day' * p_days;

    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RETURN v_deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estadísticas de presencia
CREATE OR REPLACE FUNCTION presence.get_presence_stats(p_days integer DEFAULT 30)
RETURNS TABLE(
    state_name varchar,
    total_changes bigint,
    avg_duration_minutes numeric
) AS $$
BEGIN
    RETURN QUERY
    WITH state_changes AS (
        SELECT
            ps.name as state_name,
            lph.user_id,
            lph.changed_at,
            LEAD(lph.changed_at) OVER (PARTITION BY lph.user_id ORDER BY lph.changed_at) as next_change
        FROM presence.log_presence_history lph
        JOIN presence.mst_presence_states ps ON lph.to_state_id = ps.id
        WHERE lph.changed_at >= now() - interval '1 day' * p_days
    )
    SELECT
        sc.state_name,
        COUNT(*) as total_changes,
        ROUND(AVG(EXTRACT(EPOCH FROM (sc.next_change - sc.changed_at))/60), 1) as avg_duration_minutes
    FROM state_changes sc
    WHERE sc.next_change IS NOT NULL
    GROUP BY sc.state_name
    ORDER BY total_changes DESC;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FIN DEL ARCHIVO
-- =====================================================
