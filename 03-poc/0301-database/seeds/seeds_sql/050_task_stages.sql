-- Seeds for tasks.mst_task_stages
-- Generated from sources/task stage

INSERT INTO tasks.mst_task_stages (id, name, description, stage_order, created_by) VALUES
  (gen_random_uuid(), 'Backlog', 'Task is in the backlog, waiting to be started', 1, (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Defined', 'Task requirements and scope are defined', 2, (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Planned', 'Task is planned and ready for execution', 3, (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'In progress', 'Task is actively being worked on', 4, (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Test', 'Task is under testing and validation', 5, (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Completed', 'Task has been successfully completed', 6, (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Paused', 'Task has been temporarily paused', 7, (SELECT id FROM base.mst_users LIMIT 1)),
  (gen_random_uuid(), 'Canceled', 'Task has been canceled', 8, (SELECT id FROM base.mst_users LIMIT 1))
ON CONFLICT (stage_order) DO NOTHING;

