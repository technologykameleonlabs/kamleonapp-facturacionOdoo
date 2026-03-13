-- Seeds for projects.mst_project_stages
-- Generated from sources/project stage

-- Etapas para Product - Web App
INSERT INTO projects.mst_project_stages (id, name, description, stage_order, project_type_id, created_by)
SELECT
  gen_random_uuid(),
  'Backlog',
  'Project in backlog, waiting to be started',
  1,
  pt.id,
  (SELECT id FROM base.mst_users LIMIT 1)
FROM projects.mst_project_types pt
WHERE pt.name = 'Product - Web App'
ON CONFLICT (project_type_id, name) DO NOTHING;

INSERT INTO projects.mst_project_stages (id, name, description, stage_order, project_type_id, created_by)
SELECT
  gen_random_uuid(),
  'Defined',
  'Project requirements and scope defined',
  2,
  pt.id,
  (SELECT id FROM base.mst_users LIMIT 1)
FROM projects.mst_project_types pt
WHERE pt.name = 'Product - Web App'
ON CONFLICT (project_type_id, name) DO NOTHING;

INSERT INTO projects.mst_project_stages (id, name, description, stage_order, project_type_id, created_by)
SELECT
  gen_random_uuid(),
  'Planned',
  'Project planning and timeline established',
  3,
  pt.id,
  (SELECT id FROM base.mst_users LIMIT 1)
FROM projects.mst_project_types pt
WHERE pt.name = 'Product - Web App'
ON CONFLICT (project_type_id, name) DO NOTHING;

INSERT INTO projects.mst_project_stages (id, name, description, stage_order, project_type_id, created_by)
SELECT
  gen_random_uuid(),
  'In progress',
  'Project actively being developed',
  4,
  pt.id,
  (SELECT id FROM base.mst_users LIMIT 1)
FROM projects.mst_project_types pt
WHERE pt.name = 'Product - Web App'
ON CONFLICT (project_type_id, name) DO NOTHING;

INSERT INTO projects.mst_project_stages (id, name, description, stage_order, project_type_id, created_by)
SELECT
  gen_random_uuid(),
  'Test',
  'Quality assurance and testing phase',
  5,
  pt.id,
  (SELECT id FROM base.mst_users LIMIT 1)
FROM projects.mst_project_types pt
WHERE pt.name = 'Product - Web App'
ON CONFLICT (project_type_id, name) DO NOTHING;

INSERT INTO projects.mst_project_stages (id, name, description, stage_order, project_type_id, created_by)
SELECT
  gen_random_uuid(),
  'Completed',
  'Project successfully delivered',
  6,
  pt.id,
  (SELECT id FROM base.mst_users LIMIT 1)
FROM projects.mst_project_types pt
WHERE pt.name = 'Product - Web App'
ON CONFLICT (project_type_id, name) DO NOTHING;

INSERT INTO projects.mst_project_stages (id, name, description, stage_order, project_type_id, created_by)
SELECT
  gen_random_uuid(),
  'Paused',
  'Project temporarily on hold',
  7,
  pt.id,
  (SELECT id FROM base.mst_users LIMIT 1)
FROM projects.mst_project_types pt
WHERE pt.name = 'Product - Web App'
ON CONFLICT (project_type_id, name) DO NOTHING;

INSERT INTO projects.mst_project_stages (id, name, description, stage_order, project_type_id, created_by)
SELECT
  gen_random_uuid(),
  'Canceled',
  'Project has been canceled',
  8,
  pt.id,
  (SELECT id FROM base.mst_users LIMIT 1)
FROM projects.mst_project_types pt
WHERE pt.name = 'Product - Web App'
ON CONFLICT (project_type_id, name) DO NOTHING;

