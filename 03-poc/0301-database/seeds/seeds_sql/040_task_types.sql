-- Seeds for tasks.mst_task_types
-- Generated from sources/task types

-- Analysis & Planning tasks
INSERT INTO tasks.mst_task_types (id, name, description, dedication_type, created_by) VALUES
  (gen_random_uuid(), 'Requirements Gathering', 'Collect and document project requirements', 'analysis', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Business Analysis', 'Analyze business needs and processes', 'analysis', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Technical Analysis', 'Evaluate technical feasibility and architecture', 'analysis', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Project Planning', 'Create project plans and timelines', 'management', (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

-- Design & UX/UI tasks
INSERT INTO tasks.mst_task_types (id, name, description, dedication_type, created_by) VALUES
  (gen_random_uuid(), 'UI/UX Design', 'Design user interfaces and experiences', 'design', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Wireframing', 'Create wireframes and user flows', 'design', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Mockup Creation', 'Develop visual mockups and prototypes', 'design', (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

-- Development & Coding tasks
INSERT INTO tasks.mst_task_types (id, name, description, dedication_type, created_by) VALUES
  (gen_random_uuid(), 'Frontend Development', 'Develop frontend components and interfaces', 'technical', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Backend Development', 'Develop backend logic and APIs', 'technical', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'API Development', 'Build and document APIs', 'technical', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Database Design', 'Design database schemas and relationships', 'technical', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Feature Development', 'Implement new features and functionality', 'technical', (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

-- Testing & Quality Assurance tasks
INSERT INTO tasks.mst_task_types (id, name, description, dedication_type, created_by) VALUES
  (gen_random_uuid(), 'Unit Testing', 'Write and execute unit tests', 'quality', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Integration Testing', 'Test component integration', 'quality', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'User Acceptance Testing', 'Validate with end users', 'quality', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Performance Testing', 'Test system performance and scalability', 'quality', (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

-- DevOps & Deployment tasks
INSERT INTO tasks.mst_task_types (id, name, description, dedication_type, created_by) VALUES
  (gen_random_uuid(), 'Infrastructure Setup', 'Configure servers and infrastructure', 'technical', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'CI/CD Pipeline', 'Set up continuous integration and deployment', 'technical', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Deployment Automation', 'Automate deployment processes', 'technical', (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

-- Documentation tasks
INSERT INTO tasks.mst_task_types (id, name, description, dedication_type, created_by) VALUES
  (gen_random_uuid(), 'Technical Documentation', 'Create technical documentation', 'documentation', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'API Documentation', 'Document APIs and endpoints', 'documentation', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'User Guides', 'Create user manuals and guides', 'documentation', (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

-- Project Management tasks
INSERT INTO tasks.mst_task_types (id, name, description, dedication_type, created_by) VALUES
  (gen_random_uuid(), 'Project Coordination', 'Coordinate project activities', 'management', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Stakeholder Communication', 'Communicate with project stakeholders', 'management', (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Progress Tracking', 'Monitor and report project progress', 'management', (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (name) DO NOTHING;

