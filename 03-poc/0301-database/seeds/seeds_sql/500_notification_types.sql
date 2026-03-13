-- =============================================================================
-- EP-025: SEEDS PARA TIPOS DE NOTIFICACIÓN
-- =============================================================================
-- Propósito: Tipos de notificación disponibles en el sistema
-- Tabla: notifications.mst_notification_types
-- =============================================================================

-- Tipos de notificación básicos del sistema
INSERT INTO notifications.mst_notification_types (code, name, description, module, category, priority, is_active)
VALUES
('presence_change', 'Cambio de Estado de Presencia', 'Notificación cuando un usuario cambia su estado de presencia', 'presence', 'info', 'normal', true),
('presence_critical', 'Estado de Presencia Crítico', 'Notificación para estados críticos como enfermo o vacaciones', 'presence', 'warning', 'high', true),
('task_assigned', 'Tarea Asignada', 'Notificación cuando se asigna una tarea nueva', 'tasks', 'info', 'normal', true),
('task_due_soon', 'Tarea Próxima a Vencer', 'Recordatorio de tarea próxima a vencer', 'tasks', 'warning', 'high', true),
('task_overdue', 'Tarea Vencida', 'Alerta de tarea vencida', 'tasks', 'critical', 'high', true),
('project_deadline', 'Fecha Límite de Proyecto', 'Recordatorio de fecha límite próxima', 'projects', 'warning', 'high', true),
('approval_needed', 'Aprobación Requerida', 'Se necesita aprobación para un cambio', 'workflows', 'warning', 'high', true),
('approval_rejected', 'Aprobación Rechazada', 'Una solicitud fue rechazada', 'workflows', 'critical', 'high', true),
('time_entry_reminder', 'Recordatorio de Registro de Tiempo', 'Recordatorio para registrar tiempo trabajado', 'time', 'info', 'normal', true),
('budget_alert', 'Alerta de Presupuesto', 'Alerta sobre desviaciones en presupuesto', 'budgeting', 'warning', 'high', true),
('system_maintenance', 'Mantenimiento del Sistema', 'Notificación de mantenimiento programado', 'system', 'info', 'normal', true),
('welcome_new_user', 'Bienvenido', 'Mensaje de bienvenida para nuevos usuarios', 'system', 'info', 'normal', true)
ON CONFLICT (code) DO NOTHING;

-- Verificar que se insertaron correctamente
SELECT
    code,
    name,
    module,
    category,
    priority
FROM notifications.mst_notification_types
ORDER BY module, priority DESC;
