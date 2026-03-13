-- EP-017 — Gestión Básica de Canales Discord
-- Versión básica: Solo creación automática de canales por proyecto

-- Crear esquema discord
CREATE SCHEMA IF NOT EXISTS discord;
COMMENT ON SCHEMA discord IS 'Sistema básico de gestión de canales Discord';

-- Tipos básicos de canales
CREATE TABLE IF NOT EXISTS discord.mst_channel_types (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code varchar(20) NOT NULL UNIQUE,
    name varchar(100) NOT NULL,
    description text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE discord.mst_channel_types IS 'Tipos básicos de canales Discord';
COMMENT ON COLUMN discord.mst_channel_types.code IS 'Código del tipo (project, general)';

-- Canales básicos
CREATE TABLE IF NOT EXISTS discord.trn_channels (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    discord_channel_id varchar(50), -- ID del canal en Discord
    name varchar(100) NOT NULL,
    project_id uuid, -- FK a projects.trn_projects
    type_id uuid NOT NULL, -- FK a discord.mst_channel_types
    status varchar(20) DEFAULT 'active' CHECK (status IN ('active', 'archived', 'inactive')),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE discord.trn_channels IS 'Canales básicos de Discord';
COMMENT ON COLUMN discord.trn_channels.discord_channel_id IS 'ID único del canal en Discord API';
COMMENT ON COLUMN discord.trn_channels.project_id IS 'Proyecto asociado (NULL para canales generales)';

-- Miembros de canales
CREATE TABLE IF NOT EXISTS discord.rel_channel_members (
    channel_id uuid NOT NULL,
    user_id uuid NOT NULL,
    joined_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (channel_id, user_id)
);

COMMENT ON TABLE discord.rel_channel_members IS 'Relación entre canales y miembros';
COMMENT ON COLUMN discord.rel_channel_members.joined_at IS 'Fecha de unión al canal';

-- Extensión a tabla de proyectos
ALTER TABLE projects.trn_projects
ADD COLUMN IF NOT EXISTS discord_channel_id uuid;

COMMENT ON COLUMN projects.trn_projects.discord_channel_id IS 'ID del canal Discord asociado al proyecto';

-- Índices básicos
CREATE INDEX IF NOT EXISTS idx_discord_channels_project ON discord.trn_channels(project_id) WHERE project_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_discord_channels_type ON discord.trn_channels(type_id);
CREATE INDEX IF NOT EXISTS idx_discord_channel_members_user ON discord.rel_channel_members(user_id);

-- Foreign Keys
ALTER TABLE discord.trn_channels
ADD CONSTRAINT fk_discord_channels_project
FOREIGN KEY (project_id) REFERENCES projects.trn_projects(id)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE discord.trn_channels
ADD CONSTRAINT fk_discord_channels_type
FOREIGN KEY (type_id) REFERENCES discord.mst_channel_types(id)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE discord.rel_channel_members
ADD CONSTRAINT fk_discord_members_channel
FOREIGN KEY (channel_id) REFERENCES discord.trn_channels(id)
ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE discord.rel_channel_members
ADD CONSTRAINT fk_discord_members_user
FOREIGN KEY (user_id) REFERENCES base.mst_users(id)
ON UPDATE CASCADE ON DELETE CASCADE;

-- Datos maestros básicos
INSERT INTO discord.mst_channel_types (code, name, description)
VALUES
    ('project', 'Project Channel', 'Canal específico para un proyecto'),
    ('general', 'General Channel', 'Canal general de comunicación')
ON CONFLICT (code) DO NOTHING;

-- Función básica para crear canal de proyecto
CREATE OR REPLACE FUNCTION discord.create_project_channel(p_project_id uuid, p_project_code varchar)
RETURNS uuid AS $$
DECLARE
    v_channel_id uuid;
    v_type_id uuid;
BEGIN
    -- Obtener el ID del tipo 'project'
    SELECT id INTO v_type_id
    FROM discord.mst_channel_types
    WHERE code = 'project';

    IF v_type_id IS NULL THEN
        RAISE EXCEPTION 'Channel type "project" not found';
    END IF;

    -- Crear el canal
    INSERT INTO discord.trn_channels (name, project_id, type_id, discord_channel_id)
    VALUES (
        'proj-' || lower(p_project_code),
        p_project_id,
        v_type_id,
        gen_random_uuid()::text -- Temporal, será reemplazado por ID real de Discord
    )
    RETURNING id INTO v_channel_id;

    -- Vincular el canal al proyecto
    UPDATE projects.trn_projects
    SET discord_channel_id = v_channel_id
    WHERE id = p_project_id;

    RETURN v_channel_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION discord.create_project_channel(uuid, varchar) IS 'Crear canal básico para un proyecto';

-- Actualizar timestamps automáticamente
CREATE OR REPLACE FUNCTION discord.update_updated_at()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
DROP TRIGGER IF EXISTS trg_discord_channel_types_updated ON discord.mst_channel_types;
CREATE TRIGGER trg_discord_channel_types_updated
    BEFORE UPDATE ON discord.mst_channel_types
    FOR EACH ROW EXECUTE FUNCTION discord.update_updated_at();

DROP TRIGGER IF EXISTS trg_discord_channels_updated ON discord.trn_channels;
CREATE TRIGGER trg_discord_channels_updated
    BEFORE UPDATE ON discord.trn_channels
    FOR EACH ROW EXECUTE FUNCTION discord.update_updated_at();
