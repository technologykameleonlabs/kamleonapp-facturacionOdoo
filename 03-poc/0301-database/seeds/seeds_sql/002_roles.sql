-- =====================================================
-- SEEDS: Roles del Sistema
-- =====================================================
-- Poblar base.mst_roles con los roles principales
-- =====================================================

INSERT INTO base.mst_roles (
    id,
    name,
    description
) VALUES
-- Administrador
(
    gen_random_uuid(),
    'Administrador',
    'Usuario con acceso completo a todas las funcionalidades del sistema'
),
-- Director
(
    gen_random_uuid(),
    'Director',
    'Usuario ejecutivo con permisos estratégicos y de supervisión'
),
-- CTO
(
    gen_random_uuid(),
    'CTO',
    'Usuario técnico con permisos de arquitectura y tecnología'
),
-- Project Manager
(
    gen_random_uuid(),
    'Project Manager',
    'Usuario con permisos de gestión de proyectos y equipos'
),
-- Miembro del equipo
(
    gen_random_uuid(),
    'Miembro del equipo',
    'Usuario estándar con permisos básicos de trabajo diario'
)
ON CONFLICT (name) DO NOTHING;
