-- =============================================================================
-- EP-025: SEEDS PARA HISTORIAL DE NOTIFICACIONES
-- =============================================================================
-- Propósito: Historial de notificaciones enviadas para testing
-- Tabla: notifications.log_notifications
-- =============================================================================

-- Insertar algunas notificaciones simples de ejemplo
INSERT INTO notifications.log_notifications (
    notification_type_id,
    sender_user_id,
    recipient_user_id,
    subject,
    body,
    sent_at,
    status
) VALUES
(
    (SELECT id FROM notifications.mst_notification_types WHERE code = 'presence_change'),
    '550e8400-e29b-41d4-a716-446655440001'::uuid,
    '550e8400-e29b-41d4-a716-446655440002'::uuid,
    'Cambio de estado',
    '<p>Un usuario cambió su estado de presencia.</p>',
    now() - interval '2 days',
    'read'
),
(
    (SELECT id FROM notifications.mst_notification_types WHERE code = 'task_assigned'),
    '550e8400-e29b-41d4-a716-446655440003'::uuid,
    '550e8400-e29b-41d4-a716-446655440004'::uuid,
    'Nueva tarea asignada',
    '<p>Se te ha asignado una nueva tarea.</p>',
    now() - interval '1 day',
    'delivered'
);

-- Verificar que se insertaron correctamente
SELECT
    nt.name as notification_type,
    ln.subject,
    ln.sent_at,
    ln.status
FROM notifications.log_notifications ln
JOIN notifications.mst_notification_types nt ON ln.notification_type_id = nt.id
ORDER BY ln.sent_at DESC;
