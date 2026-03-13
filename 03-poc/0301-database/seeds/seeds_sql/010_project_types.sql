-- Seeds for projects.mst_project_types
-- Generated from sources/tipos de proyecto (Nivel 1 + Nivel 2 combinations)

INSERT INTO projects.mst_project_types (id, name, description, created_by) VALUES
  (gen_random_uuid(), 'Product - Web App', 'Product development focused on web applications', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Product - AI', 'Product development with AI capabilities', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Service - Web App', 'Service delivery through web applications', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Service - AI', 'AI-powered service delivery', (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

