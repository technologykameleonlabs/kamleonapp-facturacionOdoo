-- =============================================================================
-- EP-025: SEEDS PARA TEMPLATES DE NOTIFICACIÓN
-- =============================================================================
-- Propósito: Templates HTML para diferentes tipos de notificación
-- Tabla: notifications.cfg_notification_templates
-- =============================================================================

-- Template para cambio de estado de presencia
INSERT INTO notifications.cfg_notification_templates (
    notification_type_id,
    name,
    subject_template,
    body_template,
    content_type
)
SELECT
    nt.id,
    'Template Cambio de Estado',
    '{{user_name}} cambió su estado a "{{new_state}}"',
    '<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f8f9fa; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { color: #495057; border-bottom: 2px solid #007bff; padding-bottom: 10px; margin-bottom: 20px; }
        .content { margin: 20px 0; line-height: 1.6; }
        .state-change { background: #e3f2fd; padding: 15px; border-radius: 5px; margin: 15px 0; border-left: 4px solid #007bff; }
        .footer { color: #6c757d; font-size: 12px; margin-top: 20px; border-top: 1px solid #dee2e6; padding-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🔄 Cambio de Estado de Presencia</h2>
        </div>
        <div class="content">
            <p>Hola,</p>

            <div class="state-change">
                <p><strong>{{user_name}}</strong> cambió su estado de presencia:</p>
                <p><span style="color: #6c757d;">De:</span> {{old_state}}</p>
                <p><span style="color: #007bff; font-weight: bold;">A:</span> {{new_state}}</p>
                {{#state_category}}
                <p><em>Categoría: {{state_category}}</em></p>
                {{/state_category}}
                {{#justification}}
                <p><em>"{{justification}}"</em></p>
                {{/justification}}
            </div>

            {{#is_temporary}}
            <p>⏰ <strong>Estado temporal</strong> - Expira: {{expires_at}}</p>
            {{/is_temporary}}

            <p>Esta información se actualiza automáticamente en los dashboards del equipo.</p>
        </div>
        <div class="footer">
            <p>Esta es una notificación automática del Sistema de Presencia.</p>
            <p>Fecha: {{current_date}}</p>
        </div>
    </div>
</body>
</html>',
    'text/html'
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_change'
ON CONFLICT DO NOTHING;

-- Template para estados críticos
INSERT INTO notifications.cfg_notification_templates (
    notification_type_id,
    name,
    subject_template,
    body_template,
    content_type
)
SELECT
    nt.id,
    'Template Estado Crítico',
    '🚨 {{user_name}} está {{new_state}}',
    '<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #fff3cd; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; border: 1px solid #ffeaa7; }
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
                <h3>{{user_name}} reportó estado: <strong>{{new_state}}</strong></h3>
                {{#justification}}
                <p><em>"{{justification}}"</em></p>
                {{/justification}}
                <p><strong>Fecha del cambio:</strong> {{current_date}}</p>
                {{#is_temporary}}
                <p><strong>Retorno esperado:</strong> {{expires_at}}</p>
                {{/is_temporary}}
            </div>

            <div class="actions">
                <h4>Acciones recomendadas:</h4>
                <ul>
                    <li>Considerar redistribución de tareas si es necesario</li>
                    <li>Contactar al usuario para ofrecer apoyo</li>
                    <li>Actualizar planes de proyecto si afecta entregas</li>
                </ul>
            </div>

            <p>Para más información, accede al panel de equipo.</p>
        </div>
    </div>
</body>
</html>',
    'text/html'
FROM notifications.mst_notification_types nt
WHERE nt.code = 'presence_critical'
ON CONFLICT DO NOTHING;

-- Template para tarea asignada
INSERT INTO notifications.cfg_notification_templates (
    notification_type_id,
    name,
    subject_template,
    body_template,
    content_type
)
SELECT
    nt.id,
    'Template Tarea Asignada',
    'Nueva tarea asignada: {{task_title}}',
    '<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f8f9fa; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { color: #495057; border-bottom: 2px solid #28a745; padding-bottom: 10px; margin-bottom: 20px; }
        .content { margin: 20px 0; line-height: 1.6; }
        .task-info { background: #d4edda; padding: 15px; border-radius: 5px; margin: 15px 0; border-left: 4px solid #28a745; }
        .actions { background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>📋 Nueva Tarea Asignada</h2>
        </div>
        <div class="content">
            <p>Hola <strong>{{assignee_name}}</strong>,</p>

            <div class="task-info">
                <h3>{{task_title}}</h3>
                {{#task_description}}
                <p>{{task_description}}</p>
                {{/task_description}}
                <p><strong>Proyecto:</strong> {{project_name}}</p>
                {{#due_date}}
                <p><strong>Fecha límite:</strong> {{due_date}}</p>
                {{/due_date}}
                <p><strong>Prioridad:</strong> {{priority}}</p>
            </div>

            <div class="actions">
                <p>Para comenzar a trabajar en esta tarea:</p>
                <ol>
                    <li>Accede al sistema de gestión de tareas</li>
                    <li>Busca la tarea por título o ID</li>
                    <li>Actualiza el estado a "En progreso"</li>
                    <li>Registra el tiempo dedicado según corresponda</li>
                </ol>
            </div>

            <p>¿Necesitas ayuda con esta tarea? No dudes en contactar al asignador.</p>
        </div>
    </div>
</body>
</html>',
    'text/html'
FROM notifications.mst_notification_types nt
WHERE nt.code = 'task_assigned'
ON CONFLICT DO NOTHING;

-- Template para recordatorio de tiempo
INSERT INTO notifications.cfg_notification_templates (
    notification_type_id,
    name,
    subject_template,
    body_template,
    content_type
)
SELECT
    nt.id,
    'Template Recordatorio de Tiempo',
    'Recordatorio: Registra tu tiempo trabajado hoy',
    '<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f8f9fa; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { color: #495057; border-bottom: 2px solid #17a2b8; padding-bottom: 10px; margin-bottom: 20px; }
        .content { margin: 20px 0; line-height: 1.6; }
        .reminder { background: #d1ecf1; padding: 15px; border-radius: 5px; margin: 15px 0; border-left: 4px solid #17a2b8; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>⏰ Recordatorio de Registro de Tiempo</h2>
        </div>
        <div class="content">
            <p>Hola <strong>{{user_name}}</strong>,</p>

            <div class="reminder">
                <p>Te recordamos que registres el tiempo que has dedicado a tus tareas hoy.</p>
                <p>Esto nos ayuda a:</p>
                <ul>
                    <li>Rastrear el progreso real de los proyectos</li>
                    <li>Generar reportes precisos para clientes</li>
                    <li>Optimizar la asignación de recursos</li>
                </ul>
            </div>

            <p>¿Aún no has registrado tiempo hoy? <a href="{{time_entry_url}}">Haz clic aquí para registrar</a></p>

            <p>¡Gracias por tu colaboración!</p>
        </div>
    </div>
</body>
</html>',
    'text/html'
FROM notifications.mst_notification_types nt
WHERE nt.code = 'time_entry_reminder'
ON CONFLICT DO NOTHING;

-- Verificar que se insertaron correctamente
SELECT
    nt.name as notification_type,
    t.name as template_name,
    t.subject_template
FROM notifications.cfg_notification_templates t
JOIN notifications.mst_notification_types nt ON t.notification_type_id = nt.id
ORDER BY nt.module, nt.name;
