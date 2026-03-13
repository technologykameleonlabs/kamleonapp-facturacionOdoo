-- SEEDS PARA discord.mst_channel_types
-- Tipos adicionales de canales Discord (además de los básicos project/general)

INSERT INTO discord.mst_channel_types (id, code, name, description)
VALUES
    -- Tipos ya existentes (se omitirán por conflicto)
    (gen_random_uuid(), 'project', 'Project Channel', 'Canal específico para un proyecto'),
    (gen_random_uuid(), 'general', 'General Channel', 'Canal general de comunicación'),

    -- Nuevos tipos adicionales
    (gen_random_uuid(), 'department', 'Department Channel', 'Canal para un departamento específico'),
    (gen_random_uuid(), 'team', 'Team Channel', 'Canal para equipos de trabajo'),
    (gen_random_uuid(), 'announcements', 'Announcements Channel', 'Canal para anuncios importantes'),
    (gen_random_uuid(), 'support', 'Support Channel', 'Canal para soporte técnico'),
    (gen_random_uuid(), 'feedback', 'Feedback Channel', 'Canal para retroalimentación'),
    (gen_random_uuid(), 'random', 'Random Channel', 'Canal para conversaciones casuales')
ON CONFLICT (code) DO NOTHING;

-- Verificación de inserciones
SELECT 'Tipos de canales Discord disponibles:' as verification;
SELECT code, name, description
FROM discord.mst_channel_types
ORDER BY code;
