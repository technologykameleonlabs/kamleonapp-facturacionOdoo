-- =============================================================================
-- EP-025: SISTEMA GENÉRICO DE NOTIFICACIONES (VERSIÓN SIMPLE)
-- =============================================================================
-- Propósito: Sistema básico de notificaciones reutilizable
-- Funcionalidad: Templates HTML simples, notificaciones por email
-- =============================================================================

-- =====================================================
-- ESQUEMA Y TABLAS BÁSICAS
-- =====================================================

CREATE SCHEMA IF NOT EXISTS notifications;
COMMENT ON SCHEMA notifications IS 'Sistema básico de notificaciones reutilizable';

-- Tipos de notificaciones
CREATE TABLE IF NOT EXISTS notifications.mst_notification_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code varchar(100) NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    description text,
    module varchar(100),
    category varchar(50) DEFAULT 'info',
    priority varchar(20) DEFAULT 'normal',
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now()
);

-- Templates de notificaciones
CREATE TABLE IF NOT EXISTS notifications.cfg_notification_templates (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_type_id uuid NOT NULL,
    name varchar(255) NOT NULL,
    subject_template text,
    body_template text NOT NULL,
    content_type varchar(50) DEFAULT 'text/html',
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(),

    CONSTRAINT fk_cfg_notification_templates_type FOREIGN KEY (notification_type_id)
        REFERENCES notifications.mst_notification_types(id) ON DELETE CASCADE
);

-- Historial de notificaciones
CREATE TABLE IF NOT EXISTS notifications.log_notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_type_id uuid NOT NULL,
    sender_user_id uuid,
    recipient_user_id uuid NOT NULL,
    subject text,
    body text NOT NULL,
    sent_at timestamptz DEFAULT now(),
    read_at timestamptz,
    status varchar(50) DEFAULT 'sent',

    CONSTRAINT fk_log_notifications_type FOREIGN KEY (notification_type_id)
        REFERENCES notifications.mst_notification_types(id),
    CONSTRAINT fk_log_notifications_sender FOREIGN KEY (sender_user_id)
        REFERENCES base.mst_users(id),
    CONSTRAINT fk_log_notifications_recipient FOREIGN KEY (recipient_user_id)
        REFERENCES base.mst_users(id)
);

-- =====================================================
-- FUNCIONES BÁSICAS
-- =====================================================

-- Función para enviar notificaciones
CREATE OR REPLACE FUNCTION notifications.send_notification(
    p_type_code varchar,
    p_sender_user_id uuid,
    p_recipient_user_id uuid,
    p_context jsonb DEFAULT '{}'::jsonb
)
RETURNS boolean AS $$
DECLARE
    v_notification_type_id uuid;
    v_template record;
    v_subject text;
    v_body text;
BEGIN
    -- Obtener el tipo de notificación
    SELECT id INTO v_notification_type_id
    FROM notifications.mst_notification_types
    WHERE code = p_type_code AND is_active = true;

    IF v_notification_type_id IS NULL THEN
        RETURN false;
    END IF;

    -- Obtener template
    SELECT * INTO v_template
    FROM notifications.cfg_notification_templates
    WHERE notification_type_id = v_notification_type_id
      AND is_active = true
    LIMIT 1;

    IF v_template IS NULL THEN
        RETURN false;
    END IF;

    -- Reemplazar variables
    v_subject := COALESCE(notifications._replace_vars(v_template.subject_template, p_context), v_template.name);
    v_body := notifications._replace_vars(v_template.body_template, p_context);

    -- Insertar notificación
    INSERT INTO notifications.log_notifications (
        notification_type_id,
        sender_user_id,
        recipient_user_id,
        subject,
        body
    ) VALUES (
        v_notification_type_id,
        p_sender_user_id,
        p_recipient_user_id,
        v_subject,
        v_body
    );

    RETURN true;
END;
$$ LANGUAGE plpgsql;

-- Función para reemplazar variables
CREATE OR REPLACE FUNCTION notifications._replace_vars(
    p_template text,
    p_context jsonb
)
RETURNS text AS $$
BEGIN
    RETURN replace(
        replace(
            replace(
                replace(p_template,
                    '{{user_name}}', COALESCE(p_context->>'user_name', 'Usuario')
                ),
                '{{old_state}}', COALESCE(p_context->>'old_state', 'Sin estado')
            ),
            '{{new_state}}', COALESCE(p_context->>'new_state', 'Nuevo estado')
        ),
        '{{justification}}', COALESCE(p_context->>'justification', 'Sin justificación')
    );
END;
$$ LANGUAGE plpgsql;

-- Función para obtener notificaciones pendientes
CREATE OR REPLACE FUNCTION notifications.get_pending_notifications(p_user_id uuid)
RETURNS TABLE(subject text, body text, sent_at timestamptz) AS $$
BEGIN
    RETURN QUERY
    SELECT ln.subject, ln.body, ln.sent_at
    FROM notifications.log_notifications ln
    WHERE ln.recipient_user_id = p_user_id
      AND ln.read_at IS NULL
    ORDER BY ln.sent_at DESC
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- DATOS DE EJEMPLO
-- =====================================================

-- Tipos de notificaciones
INSERT INTO notifications.mst_notification_types (code, name, description, module, category, priority)
VALUES
('presence_change', 'Cambio de Estado', 'Cambio de estado de presencia', 'presence', 'info', 'normal'),
('task_assigned', 'Tarea Asignada', 'Nueva tarea asignada', 'tasks', 'info', 'normal'),
('approval_needed', 'Aprobación Requerida', 'Se necesita aprobación', 'workflows', 'warning', 'high')
ON CONFLICT (code) DO NOTHING;

-- Templates básicos
INSERT INTO notifications.cfg_notification_templates (notification_type_id, name, subject_template, body_template)
SELECT
    nt.id,
    'Template Básico',
    '{{user_name}} realizó un cambio',
    '<html><body><h3>Notificación</h3><p>{{user_name}} cambió de {{old_state}} a {{new_state}}</p><p>{{justification}}</p></body></html>'
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_change'
ON CONFLICT DO NOTHING;

-- =====================================================
-- FIN DEL ARCHIVO
-- =====================================================
