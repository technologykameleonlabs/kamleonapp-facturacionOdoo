-- Seeds for projects.mst_project_templates
-- Generated from sources/project template

INSERT INTO projects.mst_project_templates (id, name, description, project_type_id, default_stages, created_by) VALUES
  (gen_random_uuid(), 
   'AI Web App Development Template', 
   'Complete lifecycle template for AI-powered web application development, from concept to production and ongoing support.',
   (SELECT id FROM projects.mst_project_types WHERE name = 'Product - AI' LIMIT 1),
   '["Defined", "Planned", "In progress", "Test", "Completed"]',
   (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

INSERT INTO projects.mst_project_templates (id, name, description, project_type_id, default_stages, created_by) VALUES
  (gen_random_uuid(), 
   'AI Service Development Template', 
   'Template for developing AI-powered services and APIs with full lifecycle management.',
   (SELECT id FROM projects.mst_project_types WHERE name = 'Service - AI' LIMIT 1),
   '["Backlog", "Defined", "Planned", "In progress", "Test", "Completed"]',
   (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

