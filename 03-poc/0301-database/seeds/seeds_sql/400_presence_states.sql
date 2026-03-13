-- =============================================================================
-- EP-013: SEEDS PARA ESTADOS DE PRESENCIA
-- =============================================================================
-- Propósito: Datos maestros para el sistema de presencia
-- Tabla: presence.mst_presence_states
-- =============================================================================

-- Estados básicos de presencia
INSERT INTO presence.mst_presence_states (code, name, description, category, color, icon, requires_justification, is_temporary_allowed, sort_order)
VALUES
('conectado', 'Conectado', 'Usuario activo en el sistema, disponible para comunicación', 'available', '#28a745', '🟢', false, false, 1),
('trabajando', 'Trabajando', 'Enfocado en tareas productivas, preferiblemente no interrumpir', 'busy', '#ffc107', '💼', false, false, 2),
('en_reunion', 'En reunión', 'Participando en reunión/meeting', 'busy', '#dc3545', '📅', false, true, 3),
('en_formacion', 'En formación', 'En capacitación o curso', 'busy', '#6f42c1', '📚', false, true, 4),
('en_pausa', 'En pausa', 'Break temporal, volverá pronto', 'away', '#fd7e14', '☕', false, true, 5),
('ausente', 'Ausente', 'No disponible temporalmente (automático por inactividad)', 'away', '#6c757d', '⚫', false, false, 6),
('desconectado', 'Desconectado', 'Fuera del sistema, no disponible', 'away', '#6c757d', '⚫', false, false, 7),
('enfermo', 'Enfermo', 'Ausente por enfermedad', 'unavailable', '#dc3545', '🤒', true, false, 8),
('vacaciones', 'De vacaciones', 'Ausente por vacaciones', 'unavailable', '#17a2b8', '🏖️', true, false, 9),
('fuera_oficina', 'Fuera de oficina', 'Trabajando remotamente o en otra ubicación', 'available', '#20c997', '🏠', false, false, 10)
ON CONFLICT (code) DO NOTHING;

-- Verificar que se insertaron correctamente
SELECT
    code,
    name,
    category,
    color,
    requires_justification,
    is_temporary_allowed
FROM presence.mst_presence_states
ORDER BY sort_order;
