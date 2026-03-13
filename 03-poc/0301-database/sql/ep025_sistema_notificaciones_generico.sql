-- =============================================================================
-- EP-025: SISTEMA GENÉRICO DE NOTIFICACIONES
-- =============================================================================
-- Propósito: Sistema reutilizable de notificaciones para toda la aplicación
-- Funcionalidad: Templates HTML, múltiples canales, configuración flexible
-- =============================================================================

-- =====================================================
-- ESQUEMA Y TABLAS DEL SISTEMA
-- =====================================================

CREATE SCHEMA IF NOT EXISTS notifications;
COMMENT ON SCHEMA notifications IS 'Sistema genérico de notificaciones reutilizable por toda la aplicación';

-- =====================================================
-- 1. CATÁLOGO DE TIPOS DE NOTIFICACIONES
-- =====================================================

CREATE TABLE IF NOT EXISTS notifications.mst_notification_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code varchar(100) NOT NULL UNIQUE,
    name varchar(255) NOT NULL,
    description text,
    module varchar(100), -- 'presence', 'workflows', 'tasks', 'projects', etc.
    category varchar(50), -- 'info', 'warning', 'critical', 'reminder'
    priority varchar(20) DEFAULT 'normal', -- 'low', 'normal', 'high', 'critical'
    requires_acknowledgment boolean DEFAULT false,
    default_channels jsonb DEFAULT '["email"]'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    CONSTRAINT chk_notification_types_category CHECK (category IN ('info', 'warning', 'critical', 'reminder')),
    CONSTRAINT chk_notification_types_priority CHECK (priority IN ('low', 'normal', 'high', 'critical'))
);

COMMENT ON TABLE notifications.mst_notification_types IS 'Catálogo maestro de tipos de notificaciones disponibles en el sistema';
COMMENT ON COLUMN notifications.mst_notification_types.code IS 'Código único para identificar el tipo (ej: presence_change, approval_needed)';
COMMENT ON COLUMN notifications.mst_notification_types.module IS 'Módulo que origina la notificación';
COMMENT ON COLUMN notifications.mst_notification_types.default_channels IS 'Canales por defecto para este tipo';

-- =====================================================
-- 2. PLANTILLAS DE NOTIFICACIONES
-- =====================================================

CREATE TABLE IF NOT EXISTS notifications.cfg_notification_templates (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_type_id uuid NOT NULL,
    channel varchar(50) NOT NULL, -- 'email', 'in_app', 'slack', 'sms'
    name varchar(255) NOT NULL,
    subject_template text, -- Para email/Slack
    body_template text NOT NULL, -- HTML para emails, texto plano para otros
    content_type varchar(50) DEFAULT 'text/plain', -- 'text/plain', 'text/html', 'application/json'
    variables jsonb DEFAULT '[]'::jsonb, -- Lista de variables disponibles
    conditions jsonb DEFAULT '{}'::jsonb, -- Condiciones para usar esta plantilla
    priority integer DEFAULT 1, -- Para ordenar templates
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    CONSTRAINT fk_cfg_notification_templates_type FOREIGN KEY (notification_type_id)
        REFERENCES notifications.mst_notification_types(id) ON DELETE CASCADE,
    CONSTRAINT chk_cfg_notification_templates_channel CHECK (channel IN ('email', 'in_app', 'slack', 'sms', 'discord')),
    CONSTRAINT chk_cfg_notification_templates_content_type CHECK (content_type IN ('text/plain', 'text/html', 'application/json'))
);

COMMENT ON TABLE notifications.cfg_notification_templates IS 'Plantillas configurables para cada tipo de notificación y canal';
COMMENT ON COLUMN notifications.cfg_notification_templates.body_template IS 'Contenido HTML para emails, texto plano para otros canales';
COMMENT ON COLUMN notifications.cfg_notification_templates.variables IS 'Variables disponibles para reemplazar en la plantilla';
COMMENT ON COLUMN notifications.cfg_notification_templates.conditions IS 'Condiciones para usar esta plantilla específica';

-- =====================================================
-- 3. CONFIGURACIÓN DE DESTINATARIOS
-- =====================================================

CREATE TABLE IF NOT EXISTS notifications.cfg_notification_recipients (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_type_id uuid NOT NULL,
    name varchar(255) NOT NULL,
    recipient_type varchar(50) NOT NULL, -- 'user', 'role', 'team', 'department', 'custom'
    recipient_config jsonb NOT NULL, -- Configuración específica del tipo
    conditions jsonb DEFAULT '{}'::jsonb, -- Condiciones adicionales
    priority integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    CONSTRAINT fk_cfg_notification_recipients_type FOREIGN KEY (notification_type_id)
        REFERENCES notifications.mst_notification_types(id) ON DELETE CASCADE,
    CONSTRAINT chk_cfg_notification_recipients_type CHECK (recipient_type IN ('user', 'role', 'team', 'department', 'custom'))
);

COMMENT ON TABLE notifications.cfg_notification_recipients IS 'Configuración de destinatarios para cada tipo de notificación';
COMMENT ON COLUMN notifications.cfg_notification_recipients.recipient_type IS 'Tipo de destinatario: user específico, rol, equipo, etc.';
COMMENT ON COLUMN notifications.cfg_notification_recipients.recipient_config IS 'Configuración específica: user_id, role_name, team_id, etc.';

-- =====================================================
-- 4. HISTORIAL DE NOTIFICACIONES
-- =====================================================

CREATE TABLE IF NOT EXISTS notifications.log_notifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_type_id uuid NOT NULL,
    sender_user_id uuid, -- Usuario que origina la notificación
    recipient_user_id uuid NOT NULL, -- Usuario que recibe la notificación
    channel varchar(50) NOT NULL,
    subject text,
    body text NOT NULL,
    content_type varchar(50) DEFAULT 'text/plain',
    status varchar(50) DEFAULT 'sent', -- 'sent', 'delivered', 'read', 'failed'
    sent_at timestamptz DEFAULT now(),
    read_at timestamptz,
    failed_at timestamptz,
    error_message text,
    metadata jsonb DEFAULT '{}'::jsonb, -- Información adicional del contexto
    template_id uuid, -- Template usado para generar esta notificación
    created_at timestamptz DEFAULT now(),

    CONSTRAINT fk_log_notifications_type FOREIGN KEY (notification_type_id)
        REFERENCES notifications.mst_notification_types(id),
    CONSTRAINT fk_log_notifications_sender FOREIGN KEY (sender_user_id)
        REFERENCES base.mst_users(id),
    CONSTRAINT fk_log_notifications_recipient FOREIGN KEY (recipient_user_id)
        REFERENCES base.mst_users(id),
    CONSTRAINT fk_log_notifications_template FOREIGN KEY (template_id)
        REFERENCES notifications.cfg_notification_templates(id),
    CONSTRAINT chk_log_notifications_channel CHECK (channel IN ('email', 'in_app', 'slack', 'sms', 'discord')),
    CONSTRAINT chk_log_notifications_status CHECK (status IN ('sent', 'delivered', 'read', 'failed'))
);

COMMENT ON TABLE notifications.log_notifications IS 'Historial completo de todas las notificaciones enviadas en el sistema';
COMMENT ON COLUMN notifications.log_notifications.metadata IS 'Información contextual de la notificación (IDs relacionados, etc.)';
COMMENT ON COLUMN notifications.log_notifications.template_id IS 'Template usado para generar el contenido de la notificación';

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_mst_notification_types_code ON notifications.mst_notification_types(code);
CREATE INDEX IF NOT EXISTS idx_mst_notification_types_module ON notifications.mst_notification_types(module);
CREATE INDEX IF NOT EXISTS idx_mst_notification_types_active ON notifications.mst_notification_types(is_active);

CREATE INDEX IF NOT EXISTS idx_cfg_notification_templates_type_channel ON notifications.cfg_notification_templates(notification_type_id, channel);
CREATE INDEX IF NOT EXISTS idx_cfg_notification_templates_active ON notifications.cfg_notification_templates(is_active);

CREATE INDEX IF NOT EXISTS idx_cfg_notification_recipients_type ON notifications.cfg_notification_recipients(notification_type_id);
CREATE INDEX IF NOT EXISTS idx_cfg_notification_recipients_active ON notifications.cfg_notification_recipients(is_active);

CREATE INDEX IF NOT EXISTS idx_log_notifications_recipient ON notifications.log_notifications(recipient_user_id);
CREATE INDEX IF NOT EXISTS idx_log_notifications_type ON notifications.log_notifications(notification_type_id);
CREATE INDEX IF NOT EXISTS idx_log_notifications_status ON notifications.log_notifications(status);
CREATE INDEX IF NOT EXISTS idx_log_notifications_sent_at ON notifications.log_notifications(sent_at);
CREATE INDEX IF NOT EXISTS idx_log_notifications_read ON notifications.log_notifications(read_at) WHERE read_at IS NOT NULL;

-- =====================================================
-- FUNCIONES DEL SISTEMA
-- =====================================================

-- Función simplificada para enviar notificaciones
CREATE OR REPLACE FUNCTION notifications.send_notification(
    p_type_code varchar,
    p_sender_user_id uuid,
    p_context jsonb DEFAULT '{}'::jsonb,
    p_custom_recipients uuid[] DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
    v_notification_type_id uuid;
    v_template_id uuid;
    v_recipient_user_id uuid;
    v_recipients_sent integer := 0;
BEGIN
    -- Obtener el tipo de notificación
    SELECT id INTO v_notification_type_id
    FROM notifications.mst_notification_types
    WHERE code = p_type_code AND is_active = true;

    IF v_notification_type_id IS NULL THEN
        RAISE EXCEPTION 'Tipo de notificación no encontrado: %', p_type_code;
    END IF;

    -- Obtener template de email (simplificado)
    SELECT id INTO v_template_id
    FROM notifications.cfg_notification_templates
    WHERE notification_type_id = v_notification_type_id
      AND channel = 'email'
      AND is_active = true
    ORDER BY priority DESC
    LIMIT 1;

    IF v_template_id IS NULL THEN
        RETURN 0; -- No hay template disponible
    END IF;

    -- Procesar destinatarios
    IF p_custom_recipients IS NOT NULL THEN
        -- Usar destinatarios personalizados
        FOREACH v_recipient_user_id IN ARRAY p_custom_recipients LOOP
            PERFORM notifications._send_to_recipient(
                v_notification_type_id,
                v_template_id,
                p_sender_user_id,
                v_recipient_user_id,
                'email',
                p_context
            );
            v_recipients_sent := v_recipients_sent + 1;
        END LOOP;
    ELSE
        -- Usar destinatarios del equipo (simplificado)
        FOR v_recipient_user_id IN
            SELECT DISTINCT u.id
            FROM base.mst_users u
            WHERE u.id != p_sender_user_id
            LIMIT 5 -- Limitar para testing
        LOOP
            PERFORM notifications._send_to_recipient(
                v_notification_type_id,
                v_template_id,
                p_sender_user_id,
                v_recipient_user_id,
                'email',
                p_context
            );
            v_recipients_sent := v_recipients_sent + 1;
        END LOOP;
    END IF;

    RETURN v_recipients_sent;
END;
$$ LANGUAGE plpgsql;

-- Función auxiliar para enviar a un destinatario específico
CREATE OR REPLACE FUNCTION notifications._send_to_recipient(
    p_notification_type_id uuid,
    p_template_id uuid,
    p_sender_user_id uuid,
    p_recipient_user_id uuid,
    p_channel varchar,
    p_context jsonb
)
RETURNS void AS $$
DECLARE
    v_subject text;
    v_body text;
    v_notification_id uuid;
    v_template record;
BEGIN
    -- Obtener template
    SELECT * INTO v_template
    FROM notifications.cfg_notification_templates
    WHERE id = p_template_id;

    IF v_template IS NULL THEN
        RETURN;
    END IF;

    -- Reemplazar variables en el template
    v_subject := notifications._replace_template_variables(v_template.subject_template, p_context);
    v_body := notifications._replace_template_variables(v_template.body_template, p_context);

    -- Insertar en el historial
    INSERT INTO notifications.log_notifications (
        notification_type_id,
        sender_user_id,
        recipient_user_id,
        channel,
        subject,
        body,
        content_type,
        template_id,
        metadata
    ) VALUES (
        p_notification_type_id,
        p_sender_user_id,
        p_recipient_user_id,
        p_channel,
        v_subject,
        v_body,
        v_template.content_type,
        p_template_id,
        p_context
    ) RETURNING id INTO v_notification_id;

    -- Aquí iría la lógica real de envío (email, Slack, etc.)
    -- Por ahora solo marcamos como enviado
    UPDATE notifications.log_notifications
    SET status = 'delivered'
    WHERE id = v_notification_id;
END;
$$ LANGUAGE plpgsql;

-- Función para reemplazar variables en templates (simplificada)
CREATE OR REPLACE FUNCTION notifications._replace_template_variables(
    p_template text,
    p_context jsonb
)
RETURNS text AS $$
DECLARE
    v_result text := p_template;
BEGIN
    -- Reemplazos básicos más comunes
    v_result := replace(v_result, '{{user_name}}', COALESCE(p_context->>'user_name', 'Usuario'));
    v_result := replace(v_result, '{{old_state}}', COALESCE(p_context->>'old_state', 'Sin estado'));
    v_result := replace(v_result, '{{new_state}}', COALESCE(p_context->>'new_state', 'Nuevo estado'));
    v_result := replace(v_result, '{{justification}}', COALESCE(p_context->>'justification', 'Sin justificación'));

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener notificaciones pendientes (simplificada)
CREATE OR REPLACE FUNCTION notifications.get_pending_notifications(p_user_id uuid)
RETURNS TABLE(
    notification_id uuid,
    type_name varchar,
    subject text,
    sent_at timestamptz
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ln.id,
        nt.name,
        ln.subject,
        ln.sent_at
    FROM notifications.log_notifications ln
    JOIN notifications.mst_notification_types nt ON ln.notification_type_id = nt.id
    WHERE ln.recipient_user_id = p_user_id
      AND ln.read_at IS NULL
      AND ln.status = 'delivered'
    ORDER BY ln.sent_at DESC
    LIMIT 20;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- DATOS DE EJEMPLO PARA TESTING
-- =====================================================

-- Tipos de notificaciones básicas
INSERT INTO notifications.mst_notification_types (code, name, description, module, category, priority, requires_acknowledgment, default_channels)
VALUES
('presence_change', 'Cambio de Estado de Presencia', 'Notificación cuando un usuario cambia su estado de presencia', 'presence', 'info', 'normal', false, '["email", "in_app"]'::jsonb),
('presence_critical', 'Estado de Presencia Crítico', 'Notificación para estados críticos como enfermo o vacaciones', 'presence', 'warning', 'high', true, '["email", "in_app", "slack"]'::jsonb),
('task_assigned', 'Tarea Asignada', 'Notificación cuando se asigna una tarea', 'tasks', 'info', 'normal', false, '["email", "in_app"]'::jsonb),
('approval_needed', 'Aprobación Requerida', 'Notificación para solicitudes de aprobación', 'workflows', 'warning', 'high', true, '["email", "in_app"]'::jsonb),
('project_deadline', 'Fecha Límite de Proyecto', 'Recordatorio de fechas límite próximas', 'projects', 'warning', 'high', false, '["email", "in_app"]'::jsonb)
ON CONFLICT (code) DO NOTHING;

-- Templates HTML para emails
INSERT INTO notifications.cfg_notification_templates (notification_type_id, channel, name, subject_template, body_template, content_type, variables)
SELECT
    nt.id,
    'email',
    'Template HTML - Cambio de Estado',
    '{{user_name}} cambió su estado a "{{new_state}}"',
    '<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        .header { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .content { margin: 20px 0; line-height: 1.6; }
        .state-change { background: #e3f2fd; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .footer { color: #666; font-size: 12px; margin-top: 20px; border-top: 1px solid #eee; padding-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🔄 Cambio de Estado de Presencia</h2>
        </div>
        <div class="content">
            <p>Hola <strong>{{recipient_name}}</strong>,</p>

            <div class="state-change">
                <p><strong>{{user_name}}</strong> cambió su estado de presencia:</p>
                <p>De: <span style="color: #666;">{{old_state}}</span></p>
                <p>A: <span style="color: #007bff; font-weight: bold;">{{new_state}}</span></p>
                {{#justification}}
                <p><em>"{{justification}}"</em></p>
                {{/justification}}
            </div>

            {{#is_temporary}}
            <p>⏰ <strong>Estado temporal</strong> - Expira: {{expires_at}}</p>
            {{/is_temporary}}

            <p>Para más información, accede al sistema de presencia.</p>
        </div>
        <div class="footer">
            <p>Esta es una notificación automática del Sistema de Presencia.</p>
            <p>Fecha: {{current_date}}</p>
        </div>
    </div>
</body>
</html>',
    'text/html',
    '["user_name", "recipient_name", "old_state", "new_state", "justification", "is_temporary", "expires_at", "current_date"]'::jsonb
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_change'
ON CONFLICT DO NOTHING;

-- Template para estados críticos
INSERT INTO notifications.cfg_notification_templates (notification_type_id, channel, name, subject_template, body_template, content_type, variables)
SELECT
    nt.id,
    'email',
    'Template HTML - Estado Crítico',
    '🚨 {{user_name}} está {{state}} - Requiere atención',
    '<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #fff3cd; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; border-left: 4px solid #ffc107; }
        .header { color: #856404; background: #fff3cd; padding: 15px; margin: -20px -20px 20px -20px; border-radius: 8px 8px 0 0; }
        .content { margin: 20px 0; line-height: 1.6; }
        .critical-alert { background: #f8d7da; border: 1px solid #f5c6cb; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .actions { background: #d1ecf1; padding: 15px; border-radius: 5px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🚨 Estado de Presencia Crítico</h2>
        </div>
        <div class="content">
            <div class="critical-alert">
                <h3>{{user_name}} reportó estado: <strong>{{state}}</strong></h3>
                {{#justification}}
                <p><em>"{{justification}}"</em></p>
                {{/justification}}
                <p><strong>Fecha:</strong> {{change_date}}</p>
                {{#expected_return}}
                <p><strong>Retorno esperado:</strong> {{expected_return}}</p>
                {{/expected_return}}
            </div>

            <div class="actions">
                <h4>Acciones recomendadas:</h4>
                <ul>
                    {{#is_sick}}
                    <li>Considerar redistribución de tareas</li>
                    <li>Contactar para ofrecer apoyo</li>
                    {{/is_sick}}
                    {{#is_vacation}}
                    <li>Verificar cobertura de responsabilidades</li>
                    <li>Coordinar handoff si es necesario</li>
                    {{/is_vacation}}
                    <li>Actualizar plan de proyecto si afecta entregas</li>
                </ul>
            </div>

            <p>Para gestionar esta situación, accede al panel de equipo.</p>
        </div>
    </div>
</body>
</html>',
    'text/html',
    '["user_name", "state", "justification", "change_date", "expected_return", "is_sick", "is_vacation"]'::jsonb
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_critical'
ON CONFLICT DO NOTHING;

-- Configuración de destinatarios - Equipo del usuario
INSERT INTO notifications.cfg_notification_recipients (notification_type_id, name, recipient_type, recipient_config, conditions)
SELECT
    nt.id,
    'Equipo del usuario',
    'team',
    jsonb_build_object('source_user_id', '{{user_id}}', 'exclude_self', true),
    '{}'::jsonb
FROM notifications.mst_notification_types nt
WHERE nt.code IN ('presence_change', 'presence_critical')
ON CONFLICT DO NOTHING;

-- Configuración de destinatarios - Manager del usuario
INSERT INTO notifications.cfg_notification_recipients (notification_type_id, name, recipient_type, recipient_config, conditions)
SELECT
    nt.id,
    'Manager del usuario',
    'role',
    jsonb_build_object('source_user_id', '{{user_id}}', 'role_type', 'manager'),
    '{}'::jsonb
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_critical'
ON CONFLICT DO NOTHING;

-- =====================================================
-- INTEGRACIÓN CON EP-013 (PRESENCIA)
-- =====================================================

-- Actualizar tabla de presencia para usar el sistema de notificaciones
ALTER TABLE presence.trn_user_presence
ADD COLUMN IF NOT EXISTS last_notification_sent timestamptz;

-- Función para cambio de estado con notificaciones
CREATE OR REPLACE FUNCTION presence.change_user_presence(
    p_user_id uuid,
    p_state_code varchar,
    p_justification text DEFAULT NULL,
    p_is_temporary boolean DEFAULT false,
    p_expires_at timestamptz DEFAULT NULL
)
RETURNS uuid AS $$
DECLARE
    v_presence_id uuid;
    v_old_state_id uuid;
    v_old_state_name varchar;
    v_new_state_id uuid;
    v_new_state_name varchar;
    v_notification_context jsonb;
BEGIN
    -- Obtener estado anterior
    SELECT id, state_id INTO v_presence_id, v_old_state_id
    FROM presence.trn_user_presence
    WHERE user_id = p_user_id;

    -- Obtener nombres de estados
    SELECT name INTO v_old_state_name
    FROM presence.mst_presence_states
    WHERE id = v_old_state_id;

    SELECT id, name INTO v_new_state_id, v_new_state_name
    FROM presence.mst_presence_states
    WHERE code = p_state_code;

    IF v_new_state_id IS NULL THEN
        RAISE EXCEPTION 'Estado no encontrado: %', p_state_code;
    END IF;

    -- Actualizar o insertar estado
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
        justification = EXCLUDED.justification;

    -- Insertar en historial
    INSERT INTO presence.log_presence_history (
        user_id, from_state_id, to_state_id, changed_at, source, reason
    ) VALUES (
        p_user_id, v_old_state_id, v_new_state_id, now(), 'manual', p_justification
    );

    -- Preparar contexto para notificaciones
    SELECT jsonb_build_object(
        'user_id', p_user_id::text,
        'user_name', u.name || ' ' || COALESCE(u.surname, ''),
        'old_state', COALESCE(v_old_state_name, 'Sin estado'),
        'new_state', v_new_state_name,
        'justification', p_justification,
        'is_temporary', p_is_temporary,
        'expires_at', p_expires_at::text,
        'current_date', to_char(now(), 'DD/MM/YYYY HH24:MI')
    ) INTO v_notification_context
    FROM base.mst_users u
    WHERE u.id = p_user_id;

    -- Determinar tipo de notificación
    IF p_state_code IN ('enfermo', 'vacaciones') THEN
        -- Estado crítico
        PERFORM notifications.send_notification('presence_critical', p_user_id, v_notification_context);
    ELSE
        -- Cambio normal
        PERFORM notifications.send_notification('presence_change', p_user_id, v_notification_context);
    END IF;

    -- Retornar ID del cambio
    RETURN (SELECT id FROM presence.trn_user_presence WHERE user_id = p_user_id);
END;
$$ LANGUAGE plpgsql;

-- Función para expiración automática de estados temporales
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
            NULL
        );

        v_processed_count := v_processed_count + 1;
    END LOOP;

    RETURN v_processed_count;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- DATOS DE EJEMPLO PARA PRESENCIA
-- =====================================================

-- Estados básicos de presencia
INSERT INTO presence.mst_presence_states (code, name, category, requires_justification, color, icon)
VALUES
('conectado', 'Conectado', 'available', false, '#28a745', '🟢'),
('trabajando', 'Trabajando', 'busy', false, '#ffc107', '💼'),
('en_reunion', 'En reunión', 'busy', false, '#dc3545', '📅'),
('en_formacion', 'En formación', 'busy', false, '#6f42c1', '📚'),
('en_pausa', 'En pausa', 'away', false, '#fd7e14', '☕'),
('desconectado', 'Desconectado', 'offline', false, '#6c757d', '⚫'),
('enfermo', 'Enfermo', 'unavailable', true, '#dc3545', '🤒'),
('vacaciones', 'De vacaciones', 'unavailable', true, '#17a2b8', '🏖️')
ON CONFLICT (code) DO NOTHING;

-- =====================================================
-- FUNCIONES ADICIONALES ÚTILES
-- =====================================================

-- Función para obtener estadísticas de notificaciones
CREATE OR REPLACE FUNCTION notifications.get_notification_stats(p_days integer DEFAULT 30)
RETURNS TABLE(
    type_code varchar,
    type_name varchar,
    sent_count bigint,
    read_count bigint,
    read_rate numeric
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        nt.code,
        nt.name,
        COUNT(*) as sent_count,
        COUNT(*) FILTER (WHERE ln.read_at IS NOT NULL) as read_count,
        ROUND(
            (COUNT(*) FILTER (WHERE ln.read_at IS NOT NULL)::numeric / COUNT(*)::numeric) * 100,
            2
        ) as read_rate
    FROM notifications.log_notifications ln
    JOIN notifications.mst_notification_types nt ON ln.notification_type_id = nt.id
    WHERE ln.sent_at >= now() - interval '1 day' * p_days
    GROUP BY nt.code, nt.name
    ORDER BY sent_count DESC;
END;
$$ LANGUAGE plpgsql;

-- Función para limpiar notificaciones antiguas
CREATE OR REPLACE FUNCTION notifications.cleanup_old_notifications(p_days integer DEFAULT 90)
RETURNS integer AS $$
DECLARE
    v_deleted_count integer;
BEGIN
    DELETE FROM notifications.log_notifications
    WHERE sent_at < now() - interval '1 day' * p_days
      AND status IN ('read', 'delivered')
      AND read_at IS NOT NULL;

    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    RETURN v_deleted_count;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FIN DEL ARCHIVO
-- =====================================================
