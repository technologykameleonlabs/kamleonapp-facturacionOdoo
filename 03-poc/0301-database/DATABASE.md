# Database Snapshot

_Generated at: 2025-09-18T17:03:25.537Z_

## `analytics`

### `analytics.mst_analytics_categories`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | character varying | ? |  | - |
| `type` | character varying | ? |  | - |
| `color` | character varying | - | '#6B7280'::character varying | - |
| `is_active` | boolean | - | true | - |
| `created_at` | timestamp with time zone | - | now() | - |

### `analytics.mst_analytics_entry_types`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | character varying | ? |  | - |
| `category` | character varying | ? |  | - |
| `color` | character varying | - | '#6B7280'::character varying | - |
| `sort_order` | integer | - | 0 | - |
| `is_active` | boolean | - | true | - |
| `created_at` | timestamp with time zone | - | now() | - |

### `analytics.mst_analytics_stages`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | character varying | ? |  | - |
| `color` | character varying | - | '#6B7280'::character varying | - |
| `sort_order` | integer | - | 0 | - |
| `is_active` | boolean | - | true | - |
| `created_at` | timestamp with time zone | - | now() | - |

### `analytics.trn_analytic_entries`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `entry_date` | date | ? |  | - |
| `entry_number` | character varying | - |  | - |
| `amount` | numeric | ? |  | - |
| `original_amount` | numeric | - |  | - |
| `original_currency` | character varying | - |  | - |
| `reference_id` | uuid | ? |  | - |
| `reference_model` | character varying | ? |  | - |
| `entry_type_id` | uuid | ? |  | - |
| `category_id` | uuid | - |  | - |
| `stage_id` | uuid | ? |  | - |
| `workflow_id` | uuid | - |  | - |
| `requires_approval` | boolean | - | false | - |
| `description` | text | ? |  | - |
| `notes` | text | - |  | - |
| `created_by` | uuid | - |  | - |
| `approved_by` | uuid | - |  | - |
| `approved_at` | timestamp with time zone | - |  | - |
| `created_at` | timestamp with time zone | - | now() | - |
| `updated_at` | timestamp with time zone | - | now() | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Relations**
- `category_id`  `analytics.mst_analytics_categories.id`
- `entry_type_id`  `analytics.mst_analytics_entry_types.id`
- `stage_id`  `analytics.mst_analytics_stages.id`

**Indexes**
- `idx_analytic_entries_date`: ({entry_date})
- `idx_analytic_entries_reference`: ({reference_model,reference_id})
- `idx_analytic_entries_stage`: ({stage_id})
- `idx_analytic_entries_type`: ({entry_type_id})
- `idx_trn_analytic_entries_category_id`: ({category_id})
- `trn_analytic_entries_entry_number_key` _(unique)_: ({entry_number})

## `approval`

### `approval.cfg_workflow_notifications`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `workflow_id` | uuid | ? |  | - |
| `stage_id` | uuid | - |  | - |
| `notification_type` | character varying | ? |  | - |
| `recipient_role` | character varying | - |  | - |
| `template_subject` | text | - |  | - |
| `template_body` | text | - |  | - |
| `timing` | character varying | - | 'immediate'::character varying | - |
| `delay_hours` | integer | - | 0 | - |
| `channels` | jsonb | - | '["email"]'::jsonb | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |

**Relations**
- `stage_id`  `approval.mst_workflow_stages.id`
- `workflow_id`  `approval.mst_workflows.id`

**Indexes**
- `idx_cfg_workflow_notifications_stage`: ({stage_id})
- `idx_cfg_workflow_notifications_type`: ({notification_type})
- `idx_cfg_workflow_notifications_workflow`: ({workflow_id})
- `idx_workflow_notifications_stage`: ({stage_id})
- `idx_workflow_notifications_type`: ({notification_type})
- `idx_workflow_notifications_workflow`: ({workflow_id})

### `approval.log_workflow_approvals`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `entity_workflow_id` | uuid | ? |  | - |
| `stage_id` | uuid | ? |  | - |
| `approver_id` | uuid | ? |  | - |
| `decision` | character varying | ? |  | - |
| `decision_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `comments` | text | - |  | - |
| `metadata` | jsonb | - | '{}'::jsonb | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |

**Relations**
- `entity_workflow_id`  `approval.trn_entity_workflows.id`
- `stage_id`  `approval.mst_workflow_stages.id`

**Indexes**
- `idx_log_workflow_approvals_approver`: ({approver_id})
- `idx_log_workflow_approvals_decision`: ({decision})
- `idx_log_workflow_approvals_decision_at`: ({decision_at})
- `idx_log_workflow_approvals_entity_workflow`: ({entity_workflow_id})
- `idx_log_workflow_approvals_stage`: ({stage_id})
- `idx_workflow_approvals_approver`: ({approver_id})
- `idx_workflow_approvals_decision`: ({decision})
- `idx_workflow_approvals_decision_at`: ({decision_at})
- `idx_workflow_approvals_entity_workflow`: ({entity_workflow_id})
- `idx_workflow_approvals_stage`: ({stage_id})

### `approval.mst_workflow_stages`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `workflow_id` | uuid | ? |  | - |
| `stage_order` | integer | ? |  | - |
| `name` | character varying | ? |  | - |
| `description` | text | - |  | - |
| `required_role` | character varying | ? |  | - |
| `approval_type` | character varying | - | 'single'::character varying | - |
| `timeout_hours` | integer | - | 24 | - |
| `can_reject` | boolean | - | true | - |
| `requires_comment_on_reject` | boolean | - | true | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | - |  | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |

**Relations**
- `workflow_id`  `approval.mst_workflows.id`

**Indexes**
- `idx_mst_workflow_stages_created_by`: ({created_by})
- `idx_mst_workflow_stages_deleted_by`: ({deleted_by})
- `idx_mst_workflow_stages_role`: ({required_role})
- `idx_mst_workflow_stages_updated_by`: ({updated_by})
- `idx_mst_workflow_stages_workflow`: ({workflow_id})
- `idx_workflow_stages_role`: ({required_role})
- `idx_workflow_stages_workflow`: ({workflow_id})
- `uk_workflow_stage_order` _(unique)_: ({workflow_id,stage_order})

### `approval.mst_workflows`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | character varying | ? |  | - |
| `description` | text | - |  | - |
| `icon` | character varying | - |  | - |
| `entity_type` | character varying | ? |  | - |
| `is_active` | boolean | - | true | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `deleted_by` | uuid | - |  | - |

**Indexes**
- `idx_mst_workflows_active`: ({is_active})
- `idx_mst_workflows_deleted_by`: ({deleted_by})
- `idx_mst_workflows_entity_type`: ({entity_type})
- `uk_workflow_name_entity` _(unique)_: ({name,entity_type})

### `approval.trn_entity_workflows`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `entity_type` | character varying | ? |  | - |
| `entity_id` | uuid | ? |  | - |
| `workflow_id` | uuid | ? |  | - |
| `status` | character varying | - | 'pending'::character varying | - |
| `current_stage_id` | uuid | - |  | - |
| `assigned_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `completed_at` | timestamp with time zone | - |  | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | - |  | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Relations**
- `current_stage_id`  `approval.mst_workflow_stages.id`
- `workflow_id`  `approval.mst_workflows.id`

**Indexes**
- `idx_entity_workflows_current_stage`: ({current_stage_id})
- `idx_entity_workflows_entity`: ({entity_type,entity_id})
- `idx_entity_workflows_status`: ({status})
- `idx_entity_workflows_workflow`: ({workflow_id})
- `idx_trn_entity_workflows_created_by`: ({created_by})
- `idx_trn_entity_workflows_current_stage`: ({current_stage_id})
- `idx_trn_entity_workflows_deleted_by`: ({deleted_by})
- `idx_trn_entity_workflows_entity`: ({entity_type,entity_id})
- `idx_trn_entity_workflows_status`: ({status})
- `idx_trn_entity_workflows_updated_by`: ({updated_by})
- `idx_trn_entity_workflows_workflow`: ({workflow_id})
- `uk_entity_workflow_active` _(unique)_: ({entity_type,entity_id})

## `auth`

### `auth.audit_log_entries`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `instance_id` | uuid | - |  | - |
| `id` | uuid | ? |  | ? |
| `payload` | json | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `ip_address` | character varying | ? | ''::character varying | - |

**Indexes**
- `audit_logs_instance_id_idx`: ({instance_id})

### `auth.flow_state`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `user_id` | uuid | - |  | - |
| `auth_code` | text | ? |  | - |
| `code_challenge_method` | USER-DEFINED | ? |  | - |
| `code_challenge` | text | ? |  | - |
| `provider_type` | text | ? |  | - |
| `provider_access_token` | text | - |  | - |
| `provider_refresh_token` | text | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |
| `authentication_method` | text | ? |  | - |
| `auth_code_issued_at` | timestamp with time zone | - |  | - |

**Indexes**
- `flow_state_created_at_idx`: ({created_at})
- `idx_auth_code`: ({auth_code})
- `idx_user_id_auth_method`: ({user_id,authentication_method})

### `auth.identities`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `provider_id` | text | ? |  | - |
| `user_id` | uuid | ? |  | - |
| `identity_data` | jsonb | ? |  | - |
| `provider` | text | ? |  | - |
| `last_sign_in_at` | timestamp with time zone | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |
| `email` | text | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |

**Indexes**
- `identities_email_idx`: ({email})
- `identities_provider_id_provider_unique` _(unique)_: ({provider_id,provider})
- `identities_user_id_idx`: ({user_id})

### `auth.instances`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `uuid` | uuid | - |  | - |
| `raw_base_config` | text | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |

### `auth.mfa_amr_claims`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `session_id` | uuid | ? |  | - |
| `created_at` | timestamp with time zone | ? |  | - |
| `updated_at` | timestamp with time zone | ? |  | - |
| `authentication_method` | text | ? |  | - |
| `id` | uuid | ? |  | ? |

**Indexes**
- `mfa_amr_claims_session_id_authentication_method_pkey` _(unique)_: ({session_id,authentication_method})

### `auth.mfa_challenges`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `factor_id` | uuid | ? |  | - |
| `created_at` | timestamp with time zone | ? |  | - |
| `verified_at` | timestamp with time zone | - |  | - |
| `ip_address` | inet | ? |  | - |
| `otp_code` | text | - |  | - |
| `web_authn_session_data` | jsonb | - |  | - |

**Indexes**
- `mfa_challenge_created_at_idx`: ({created_at})

### `auth.mfa_factors`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `user_id` | uuid | ? |  | - |
| `friendly_name` | text | - |  | - |
| `factor_type` | USER-DEFINED | ? |  | - |
| `status` | USER-DEFINED | ? |  | - |
| `created_at` | timestamp with time zone | ? |  | - |
| `updated_at` | timestamp with time zone | ? |  | - |
| `secret` | text | - |  | - |
| `phone` | text | - |  | - |
| `last_challenged_at` | timestamp with time zone | - |  | - |
| `web_authn_credential` | jsonb | - |  | - |
| `web_authn_aaguid` | uuid | - |  | - |

**Indexes**
- `factor_id_created_at_idx`: ({user_id,created_at})
- `mfa_factors_last_challenged_at_key` _(unique)_: ({last_challenged_at})
- `mfa_factors_user_friendly_name_unique` _(unique)_: ({friendly_name,user_id})
- `mfa_factors_user_id_idx`: ({user_id})
- `unique_phone_factor_per_user` _(unique)_: ({user_id,phone})

### `auth.oauth_clients`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `client_id` | text | ? |  | - |
| `client_secret_hash` | text | ? |  | - |
| `registration_type` | USER-DEFINED | ? |  | - |
| `redirect_uris` | text | ? |  | - |
| `grant_types` | text | ? |  | - |
| `client_name` | text | - |  | - |
| `client_uri` | text | - |  | - |
| `logo_uri` | text | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Indexes**
- `oauth_clients_client_id_idx`: ({client_id})
- `oauth_clients_client_id_key` _(unique)_: ({client_id})
- `oauth_clients_deleted_at_idx`: ({deleted_at})

### `auth.one_time_tokens`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `user_id` | uuid | ? |  | - |
| `token_type` | USER-DEFINED | ? |  | - |
| `token_hash` | text | ? |  | - |
| `relates_to` | text | ? |  | - |
| `created_at` | timestamp without time zone | ? | now() | - |
| `updated_at` | timestamp without time zone | ? | now() | - |

**Indexes**
- `one_time_tokens_relates_to_hash_idx`: ({relates_to})
- `one_time_tokens_token_hash_hash_idx`: ({token_hash})
- `one_time_tokens_user_id_token_type_key` _(unique)_: ({user_id,token_type})

### `auth.refresh_tokens`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `instance_id` | uuid | - |  | - |
| `id` | bigint | ? | nextval('auth.refresh_tokens_id_seq'::regclass) | ? |
| `token` | character varying | - |  | - |
| `user_id` | character varying | - |  | - |
| `revoked` | boolean | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |
| `parent` | character varying | - |  | - |
| `session_id` | uuid | - |  | - |

**Indexes**
- `refresh_tokens_instance_id_idx`: ({instance_id})
- `refresh_tokens_instance_id_user_id_idx`: ({instance_id,user_id})
- `refresh_tokens_parent_idx`: ({parent})
- `refresh_tokens_session_id_revoked_idx`: ({session_id,revoked})
- `refresh_tokens_token_unique` _(unique)_: ({token})
- `refresh_tokens_updated_at_idx`: ({updated_at})

### `auth.saml_providers`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `sso_provider_id` | uuid | ? |  | - |
| `entity_id` | text | ? |  | - |
| `metadata_xml` | text | ? |  | - |
| `metadata_url` | text | - |  | - |
| `attribute_mapping` | jsonb | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |
| `name_id_format` | text | - |  | - |

**Indexes**
- `saml_providers_entity_id_key` _(unique)_: ({entity_id})
- `saml_providers_sso_provider_id_idx`: ({sso_provider_id})

### `auth.saml_relay_states`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `sso_provider_id` | uuid | ? |  | - |
| `request_id` | text | ? |  | - |
| `for_email` | text | - |  | - |
| `redirect_to` | text | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |
| `flow_state_id` | uuid | - |  | - |

**Indexes**
- `saml_relay_states_created_at_idx`: ({created_at})
- `saml_relay_states_for_email_idx`: ({for_email})
- `saml_relay_states_sso_provider_id_idx`: ({sso_provider_id})

### `auth.schema_migrations`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `version` | character varying | ? |  | ? |

### `auth.sessions`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `user_id` | uuid | ? |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |
| `factor_id` | uuid | - |  | - |
| `aal` | USER-DEFINED | - |  | - |
| `not_after` | timestamp with time zone | - |  | - |
| `refreshed_at` | timestamp without time zone | - |  | - |
| `user_agent` | text | - |  | - |
| `ip` | inet | - |  | - |
| `tag` | text | - |  | - |

**Indexes**
- `sessions_not_after_idx`: ({not_after})
- `sessions_user_id_idx`: ({user_id})
- `user_id_created_at_idx`: ({user_id,created_at})

### `auth.sso_domains`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `sso_provider_id` | uuid | ? |  | - |
| `domain` | text | ? |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |

**Indexes**
- `sso_domains_domain_idx` _(unique)_: ({})
- `sso_domains_sso_provider_id_idx`: ({sso_provider_id})

### `auth.sso_providers`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `resource_id` | text | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |
| `disabled` | boolean | - |  | - |

**Indexes**
- `sso_providers_resource_id_idx` _(unique)_: ({})
- `sso_providers_resource_id_pattern_idx`: ({resource_id})

### `auth.users`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `instance_id` | uuid | - |  | - |
| `id` | uuid | ? |  | ? |
| `aud` | character varying | - |  | - |
| `role` | character varying | - |  | - |
| `email` | character varying | - |  | - |
| `encrypted_password` | character varying | - |  | - |
| `email_confirmed_at` | timestamp with time zone | - |  | - |
| `invited_at` | timestamp with time zone | - |  | - |
| `confirmation_token` | character varying | - |  | - |
| `confirmation_sent_at` | timestamp with time zone | - |  | - |
| `recovery_token` | character varying | - |  | - |
| `recovery_sent_at` | timestamp with time zone | - |  | - |
| `email_change_token_new` | character varying | - |  | - |
| `email_change` | character varying | - |  | - |
| `email_change_sent_at` | timestamp with time zone | - |  | - |
| `last_sign_in_at` | timestamp with time zone | - |  | - |
| `raw_app_meta_data` | jsonb | - |  | - |
| `raw_user_meta_data` | jsonb | - |  | - |
| `is_super_admin` | boolean | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |
| `phone` | text | - | NULL::character varying | - |
| `phone_confirmed_at` | timestamp with time zone | - |  | - |
| `phone_change` | text | - | ''::character varying | - |
| `phone_change_token` | character varying | - | ''::character varying | - |
| `phone_change_sent_at` | timestamp with time zone | - |  | - |
| `confirmed_at` | timestamp with time zone | - |  | - |
| `email_change_token_current` | character varying | - | ''::character varying | - |
| `email_change_confirm_status` | smallint | - | 0 | - |
| `banned_until` | timestamp with time zone | - |  | - |
| `reauthentication_token` | character varying | - | ''::character varying | - |
| `reauthentication_sent_at` | timestamp with time zone | - |  | - |
| `is_sso_user` | boolean | ? | false | - |
| `deleted_at` | timestamp with time zone | - |  | - |
| `is_anonymous` | boolean | ? | false | - |

**Indexes**
- `confirmation_token_idx` _(unique)_: ({confirmation_token})
- `email_change_token_current_idx` _(unique)_: ({email_change_token_current})
- `email_change_token_new_idx` _(unique)_: ({email_change_token_new})
- `reauthentication_token_idx` _(unique)_: ({reauthentication_token})
- `recovery_token_idx` _(unique)_: ({recovery_token})
- `users_email_partial_key` _(unique)_: ({email})
- `users_instance_id_email_idx`: ({instance_id})
- `users_instance_id_idx`: ({instance_id})
- `users_is_anonymous_idx`: ({is_anonymous})
- `users_phone_key` _(unique)_: ({phone})

## `base`

### `base.cfg_mui_theme`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | text | ? |  | - |
| `is_default` | boolean | ? | false | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `user_id` | uuid | ? | auth.uid() | - |
| `theme_options` | jsonb | ? |  | - |

### `base.cfg_table_routes`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `table_name` | text | ? |  | - |
| `route_path` | text | ? |  | - |
| `display_name` | text | ? |  | - |
| `description` | text | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |
| `is_active` | boolean | ? | true | - |
| `default_depth_level` | integer | ? | 0 | - |
| `max_depth_level` | integer | ? | 2 | - |
| `metadata` | jsonb | - | '{}'::jsonb | - |
| `created_at` | timestamp with time zone | - | now() | - |
| `updated_at` | timestamp with time zone | - | now() | - |
| `crud_operations` | jsonb | ? | '{"read": true, "create": true, "delete": true, "schema": true, "update": true}'::jsonb | - |

**Indexes**
- `cfg_table_routes_route_path_key` _(unique)_: ({route_path})
- `cfg_table_routes_table_name_key` _(unique)_: ({table_name})

### `base.dat_permission`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `key` | text | ? |  | - |
| `label` | text | ? |  | - |
| `category` | text | - |  | - |
| `route` | text | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |
| `type` | text | - | 'view'::text | - |
| `created_at` | timestamp without time zone | - | now() | - |

**Indexes**
- `dat_permission_key_key` _(unique)_: ({key})

### `base.dat_profile`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `user_id` | uuid | - | auth.uid() | - |
| `id` | bigint | ? |  | ? |
| `name` | text | - |  | - |
| `image` | text | - |  | - |
| `description` | text | - |  | - |
| `data` | jsonb | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `contact_type` | text | - |  | - |
| `company_name` | text | - |  | - |
| `phone` | text | - |  | - |
| `address` | text | - |  | - |
| `sector` | text | - |  | - |
| `country` | text | - |  | - |

### `base.dat_role`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |
| `created_at` | timestamp without time zone | - | now() | - |
| `code` | text | - |  | - |
| `views` | jsonb | - |  | - |

**Indexes**
- `dat_role_name_key` _(unique)_: ({name})

### `base.dat_role_permission`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `role_id` | uuid | - |  | - |
| `permission_id` | uuid | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |
| `granted` | boolean | - | true | - |
| `created_at` | timestamp without time zone | - | now() | - |

**Relations**
- `permission_id`  `base.dat_permission.id`
- `role_id`  `base.dat_role.id`

**Indexes**
- `idx_dat_role_permission_permission_id`: ({permission_id})
- `idx_dat_role_permission_role_id`: ({role_id})

### `base.log_api_requests`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `method` | character varying | ? |  | - |
| `endpoint` | text | ? |  | - |
| `full_url` | text | - |  | - |
| `ip_address` | inet | - |  | - |
| `user_agent` | text | - |  | - |
| `request_headers` | jsonb | - |  | - |
| `request_body` | jsonb | - |  | - |
| `response_status` | integer | ? |  | - |
| `response_body` | jsonb | - |  | - |
| `execution_time_ms` | integer | - |  | - |
| `error_message` | text | - |  | - |
| `error_stack` | text | - |  | - |
| `metadata` | jsonb | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |
| `created_at` | timestamp with time zone | - | now() | - |
| `user_id` | uuid | ? | auth.uid() | - |

### `base.mst_entities`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `tax_id` | text | - |  | - |
| `address` | text | - |  | - |
| `phone` | text | - |  | - |
| `email` | text | - |  | - |
| `website` | text | - |  | - |
| `is_active` | boolean | - | true | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `multi_tenant_config` | jsonb | - | '{"enabled": true}'::jsonb | - |

**Indexes**
- `idx_mst_entities_active`: ({is_active})
- `mst_entities_tax_id_key` _(unique)_: ({tax_id})

### `base.mst_permissions`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |

**Indexes**
- `mst_permissions_name_key` _(unique)_: ({name})

### `base.mst_query_blueprints`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `name` | text | ? |  | - |
| `base_table` | text | ? |  | - |
| `spec` | jsonb | ? |  | - |
| `param_schema` | jsonb | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |
| `created_at` | timestamp with time zone | ? | now() | - |
| `user_id` | uuid | ? | auth.uid() | - |

### `base.mst_roles`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |
| `created_by` | uuid | - |  | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |

**Relations**
- `created_by`  `base.mst_users.id`
- `deleted_by`  `base.mst_users.id`
- `updated_by`  `base.mst_users.id`

**Indexes**
- `idx_mst_roles_created_by`: ({created_by})
- `idx_mst_roles_deleted_by`: ({deleted_by})
- `idx_mst_roles_updated_by`: ({updated_by})
- `mst_roles_name_key` _(unique)_: ({name})

### `base.mst_users`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? |  | ? |
| `avatar_url` | text | - |  | - |
| `bio` | text | - |  | - |
| `role_id` | uuid | - |  | - |
| `hourly_rate` | numeric | - |  | - |
| `hire_date` | timestamp with time zone | - | now() | - |
| `entity_id` | uuid | - |  | - |
| `username` | text | - |  | - |
| `email` | text | - |  | - |
| `first_name` | text | - |  | - |
| `last_name` | text | - |  | - |

**Relations**
- `role_id`  `base.mst_roles.id`
- `entity_id`  `base.mst_entities.id`

**Indexes**
- `idx_mst_users_email` _(unique)_: ({email})
- `idx_mst_users_entity`: ({entity_id})
- `idx_mst_users_role_id`: ({role_id})
- `idx_mst_users_username` _(unique)_: ({username})

### `base.rel_role_permissions`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `role_id` | uuid | ? |  | - |
| `permission_id` | uuid | ? |  | - |
| `id` | uuid | ? | gen_random_uuid() | ? |

**Relations**
- `permission_id`  `base.mst_permissions.id`
- `role_id`  `base.mst_roles.id`

**Indexes**
- `idx_rel_role_permissions_permission_id`: ({permission_id})
- `idx_rel_role_permissions_role_id`: ({role_id})

### `base.rel_user_role_entities`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `user_id` | uuid | ? |  | - |
| `role_id` | uuid | ? |  | - |
| `entity_id` | uuid | ? |  | - |
| `is_active` | boolean | - | true | - |
| `assigned_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `assigned_by` | uuid | - |  | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |

**Relations**
- `assigned_by`  `base.mst_users.id`
- `entity_id`  `base.mst_entities.id`
- `role_id`  `base.mst_roles.id`
- `user_id`  `base.mst_users.id`

**Indexes**
- `idx_rel_user_role_entities_assigned_by`: ({assigned_by})
- `idx_rel_user_role_entities_entity_id`: ({entity_id})
- `idx_rel_user_role_entities_role_id`: ({role_id})
- `idx_rel_user_role_entities_user_id`: ({user_id})

## `budgeting`

### `budgeting.log_budget_versions`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `budget_id` | uuid | ? |  | - |
| `version_number` | integer | ? |  | - |
| `raw_data` | jsonb | ? |  | - |
| `metadata` | jsonb | - | '{}'::jsonb | - |
| `change_reason` | text | - |  | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |

**Relations**
- `budget_id`  `budgeting.trn_monthly_budgets.id`

**Indexes**
- `idx_budget_versions_budget_version`: ({budget_id,version_number})
- `idx_budget_versions_created_at`: ({created_at})
- `idx_log_budget_versions_budget_version`: ({budget_id,version_number})
- `idx_log_budget_versions_created_at`: ({created_at})
- `idx_log_budget_versions_created_by`: ({created_by})

### `budgeting.log_status_history`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `budget_id` | uuid | - |  | - |
| `assignment_id` | uuid | - |  | - |
| `record_type` | text | ? |  | - |
| `old_status` | text | - |  | - |
| `new_status` | text | - |  | - |
| `workflow_step` | text | - |  | - |
| `change_reason` | text | - |  | - |
| `assigned_to` | uuid | - |  | - |
| `due_date` | date | - |  | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `changed_by` | uuid | ? |  | - |
| `cto_reviewer_id` | uuid | - |  | - |

**Relations**
- `assignment_id`  `budgeting.trn_resource_assignments.id`
- `budget_id`  `budgeting.trn_monthly_budgets.id`

**Indexes**
- `idx_log_status_history_assigned_to`: ({assigned_to})
- `idx_log_status_history_assignment_timeline`: ({assignment_id,created_at})
- `idx_log_status_history_budget_timeline`: ({budget_id,created_at})
- `idx_log_status_history_changed_by`: ({changed_by})
- `idx_log_status_history_cto_reviewer`: ({cto_reviewer_id,created_at})
- `idx_log_status_history_workflow_step`: ({workflow_step,created_at})
- `idx_status_history_assignment_timeline`: ({assignment_id,created_at})
- `idx_status_history_budget_timeline`: ({budget_id,created_at})
- `idx_status_history_workflow_step`: ({workflow_step,created_at})

### `budgeting.trn_cost_calculations`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `assignment_id` | uuid | ? |  | - |
| `cost_type` | text | ? |  | - |
| `direct_cost` | numeric | - | 0 | - |
| `indirect_cost` | numeric | - | 0 | - |
| `overhead_factor` | numeric | - | 1.0 | - |
| `currency` | text | - | 'EUR'::text | - |
| `calculated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |

**Relations**
- `assignment_id`  `budgeting.trn_resource_assignments.id`

**Indexes**
- `idx_cost_calculations_assignment_type`: ({assignment_id,cost_type})
- `idx_cost_calculations_calculated_at`: ({calculated_at})
- `idx_trn_cost_calculations_assignment_type`: ({assignment_id,cost_type})
- `idx_trn_cost_calculations_calculated_at`: ({calculated_at})

### `budgeting.trn_monthly_budgets`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `project_id` | uuid | ? |  | - |
| `budget_month` | date | ? |  | - |
| `currency` | text | - | 'EUR'::text | - |
| `status` | text | - | 'draft'::text | - |
| `total_cost` | numeric | - | 0 | - |
| `total_margin` | numeric | - | 0 | - |
| `target_margin` | numeric | - |  | - |
| `capacity_snapshot` | jsonb | - |  | - |
| `validation_notes` | text | - |  | - |
| `submitted_to_cto_at` | timestamp with time zone | - |  | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `cto_review_status` | text | - | 'pending'::text | - |
| `capacity_risk_level` | text | - | 'unknown'::text | - |
| `technical_validation_date` | timestamp with time zone | - |  | - |
| `cto_reviewer_id` | uuid | - |  | - |
| `capacity_analysis` | jsonb | - | '{}'::jsonb | - |
| `technical_report` | jsonb | - | '{}'::jsonb | - |
| `escalation_status` | text | - | 'pending'::text | - |
| `workflow_id` | uuid | - |  | - |
| `workflow_status` | character varying | - | 'not_assigned'::character varying | - |
| `current_stage` | character varying | - |  | - |
| `workflow_assigned_at` | timestamp with time zone | - |  | - |
| `workflow_completed_at` | timestamp with time zone | - |  | - |
| `followup_activated` | boolean | - | false | - |
| `followup_activated_at` | timestamp with time zone | - |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Indexes**
- `idx_monthly_budgets_currency`: ({currency})
- `idx_monthly_budgets_project_month`: ({project_id,budget_month})
- `idx_monthly_budgets_status_date`: ({status,created_at})
- `idx_monthly_budgets_workflow_id`: ({workflow_id})
- `idx_monthly_budgets_workflow_status`: ({workflow_status})
- `idx_trn_monthly_budgets_capacity_risk`: ({capacity_risk_level,budget_month})
- `idx_trn_monthly_budgets_created_by`: ({created_by})
- `idx_trn_monthly_budgets_cto_review_status`: ({cto_review_status,budget_month})
- `idx_trn_monthly_budgets_cto_reviewer`: ({cto_reviewer_id,cto_review_status})
- `idx_trn_monthly_budgets_currency`: ({currency})
- `idx_trn_monthly_budgets_project_month`: ({project_id,budget_month})
- `idx_trn_monthly_budgets_status_date`: ({status,created_at})
- `idx_trn_monthly_budgets_updated_by`: ({updated_by})

### `budgeting.trn_resource_assignments`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `budget_id` | uuid | ? |  | - |
| `employee_id` | uuid | ? |  | - |
| `dedication_percentage` | numeric | ? |  | - |
| `monthly_cost` | numeric | - |  | - |
| `status` | text | - | 'draft'::text | - |
| `validation_notes` | text | - |  | - |
| `skills_validated` | boolean | - | false | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `capacity_score` | numeric | - | 100.00 | - |
| `cto_correction_notes` | text | - |  | - |
| `technical_validation_status` | text | - | 'pending'::text | - |
| `original_dedication_percentage` | numeric | - |  | - |
| `corrected_dedication_percentage` | numeric | - |  | - |
| `revenue_contribution` | numeric | - | 0 | - |
| `margin_contribution` | numeric | - | 0 | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Relations**
- `budget_id`  `budgeting.trn_monthly_budgets.id`

**Indexes**
- `idx_resource_assignments_budget_employee`: ({budget_id,employee_id})
- `idx_resource_assignments_employee_month`: ({employee_id,created_at})
- `idx_resource_assignments_status_active`: ({status,updated_at})
- `idx_trn_resource_assignments_budget_employee`: ({budget_id,employee_id})
- `idx_trn_resource_assignments_capacity_score`: ({capacity_score})
- `idx_trn_resource_assignments_created_by`: ({created_by})
- `idx_trn_resource_assignments_employee_month`: ({employee_id,created_at})
- `idx_trn_resource_assignments_status_active`: ({status,updated_at})
- `idx_trn_resource_assignments_technical_validation`: ({technical_validation_status,budget_id})
- `idx_trn_resource_assignments_updated_by`: ({updated_by})

## `discord`

### `discord.mst_channel_types`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `code` | character varying | ? |  | - |
| `name` | character varying | ? |  | - |
| `description` | text | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |

**Indexes**
- `mst_channel_types_code_key` _(unique)_: ({code})

### `discord.rel_channel_members`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `channel_id` | uuid | ? |  | ? |
| `user_id` | uuid | ? |  | ? |
| `joined_at` | timestamp with time zone | ? | now() | - |

**Relations**
- `channel_id`  `discord.trn_channels.id`

**Indexes**
- `idx_discord_channel_members_user`: ({user_id})

### `discord.trn_channels`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `discord_channel_id` | character varying | - |  | - |
| `name` | character varying | ? |  | - |
| `project_id` | uuid | - |  | - |
| `type_id` | uuid | ? |  | - |
| `status` | character varying | - | 'active'::character varying | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |

**Relations**
- `type_id`  `discord.mst_channel_types.id`

**Indexes**
- `idx_discord_channels_project`: ({project_id})
- `idx_discord_channels_type`: ({type_id})

## `masterdata`

### `masterdata.cfg_google_calendar_integrations`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | - |  | - |
| `user_id` | uuid | - |  | - |
| `google_user_id` | character varying | - |  | - |
| `access_token` | text | - |  | - |
| `refresh_token` | text | - |  | - |
| `token_expires_at` | timestamp with time zone | - |  | - |
| `calendar_ids` | ARRAY | - |  | - |
| `sync_settings` | jsonb | - |  | - |
| `created_at` | timestamp with time zone | - |  | - |
| `updated_at` | timestamp with time zone | - |  | - |

### `masterdata.mst_contacts`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `contact_code` | character varying | ? |  | - |
| `first_name` | character varying | - |  | - |
| `last_name` | character varying | - |  | - |
| `company_name` | character varying | - |  | - |
| `contact_type` | USER-DEFINED | ? |  | - |
| `email` | character varying | ? |  | - |
| `phone` | character varying | - |  | - |
| `mobile` | character varying | - |  | - |
| `address` | text | - |  | - |
| `city` | character varying | - |  | - |
| `state` | character varying | - |  | - |
| `country` | character varying | - |  | - |
| `postal_code` | character varying | - |  | - |
| `website` | character varying | - |  | - |
| `economic_sector` | character varying | - |  | - |
| `country_iso` | character varying | - |  | - |
| `is_active` | boolean | ? | true | - |
| `notes` | text | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `created_by` | uuid | - |  | - |
| `updated_by` | uuid | - |  | - |

**Indexes**
- `idx_mst_contacts_created_by`: ({created_by})
- `idx_mst_contacts_updated_by`: ({updated_by})
- `mst_contacts_contact_code_key` _(unique)_: ({contact_code})
- `mst_contacts_email_key` _(unique)_: ({email})

### `masterdata.mst_currency_rates`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `from_currency` | text | ? |  | - |
| `to_currency` | text | ? |  | - |
| `rate` | numeric | ? |  | - |
| `valid_from` | date | ? |  | - |
| `valid_until` | date | - |  | - |
| `is_active` | boolean | - | true | - |
| `source` | text | - | 'manual'::text | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | - |  | - |

**Indexes**
- `idx_currency_rates_active`: ({from_currency,to_currency,valid_from})
- `idx_currency_rates_period`: ({valid_from,valid_until})
- `idx_mst_currency_rates_active`: ({from_currency,to_currency,valid_from})
- `idx_mst_currency_rates_created_by`: ({created_by})
- `idx_mst_currency_rates_period`: ({valid_from,valid_until})

### `masterdata.mst_employees`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `user_id` | uuid | - |  | - |
| `employee_code` | character varying | ? |  | - |
| `first_name` | character varying | ? |  | - |
| `last_name` | character varying | ? |  | - |
| `email` | character varying | ? |  | - |
| `phone` | character varying | - |  | - |
| `hourly_rate` | numeric | ? |  | - |
| `hire_date` | date | ? | CURRENT_DATE | - |
| `status` | USER-DEFINED | ? | 'activo'::masterdata.employee_status_enum | - |
| `entity_id` | uuid | - |  | - |
| `department` | character varying | - |  | - |
| `position` | character varying | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `created_by` | uuid | - |  | - |
| `updated_by` | uuid | - |  | - |

**Indexes**
- `idx_mst_employees_created_by`: ({created_by})
- `idx_mst_employees_updated_by`: ({updated_by})
- `idx_mst_employees_user_id`: ({user_id})
- `mst_employees_email_key` _(unique)_: ({email})
- `mst_employees_employee_code_key` _(unique)_: ({employee_code})

### `masterdata.mst_glossary_terms`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `term` | character varying | ? |  | - |
| `definition` | text | ? |  | - |
| `synonyms` | ARRAY | - |  | - |
| `related_terms` | ARRAY | - |  | - |
| `context` | character varying | - |  | - |
| `language` | character varying | ? | 'es'::character varying | - |
| `is_active` | boolean | ? | true | - |
| `usage_count` | integer | ? | 0 | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `created_by` | uuid | - |  | - |
| `updated_by` | uuid | - |  | - |

**Indexes**
- `idx_mst_glossary_terms_created_by`: ({created_by})
- `idx_mst_glossary_terms_updated_by`: ({updated_by})
- `mst_glossary_terms_term_key` _(unique)_: ({term})

## `notifications`

### `notifications.cfg_notification_templates`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `notification_type_id` | uuid | ? |  | - |
| `name` | character varying | ? |  | - |
| `subject_template` | text | - |  | - |
| `body_template` | text | ? |  | - |
| `content_type` | character varying | - | 'text/html'::character varying | - |
| `is_active` | boolean | - | true | - |
| `created_at` | timestamp with time zone | - | now() | - |

**Relations**
- `notification_type_id`  `notifications.mst_notification_types.id`

**Indexes**
- `idx_cfg_notification_templates_notification_type_id`: ({notification_type_id})

### `notifications.log_notifications`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `notification_type_id` | uuid | ? |  | - |
| `sender_user_id` | uuid | - |  | - |
| `recipient_user_id` | uuid | ? |  | - |
| `subject` | text | - |  | - |
| `body` | text | ? |  | - |
| `sent_at` | timestamp with time zone | - | now() | - |
| `read_at` | timestamp with time zone | - |  | - |
| `status` | character varying | - | 'sent'::character varying | - |

**Relations**
- `notification_type_id`  `notifications.mst_notification_types.id`

**Indexes**
- `idx_log_notifications_notification_type_id`: ({notification_type_id})
- `idx_log_notifications_recipient_user_id`: ({recipient_user_id})
- `idx_log_notifications_sender_user_id`: ({sender_user_id})

### `notifications.mst_notification_types`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `code` | character varying | ? |  | - |
| `name` | character varying | ? |  | - |
| `description` | text | - |  | - |
| `module` | character varying | - |  | - |
| `category` | character varying | - | 'info'::character varying | - |
| `priority` | character varying | - | 'normal'::character varying | - |
| `is_active` | boolean | - | true | - |
| `created_at` | timestamp with time zone | - | now() | - |

**Indexes**
- `mst_notification_types_code_key` _(unique)_: ({code})

## `presence`

### `presence.log_presence_history`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `user_id` | uuid | ? |  | - |
| `from_state_id` | uuid | - |  | - |
| `to_state_id` | uuid | ? |  | - |
| `changed_at` | timestamp with time zone | - | now() | - |
| `change_source` | character varying | - | 'manual'::character varying | - |
| `reason` | text | - |  | - |
| `metadata` | jsonb | - | '{}'::jsonb | - |
| `created_at` | timestamp with time zone | - | now() | - |
| `task_context` | jsonb | - | '{}'::jsonb | - |
| `project_context` | jsonb | - | '{}'::jsonb | - |

**Relations**
- `from_state_id`  `presence.mst_presence_states.id`
- `to_state_id`  `presence.mst_presence_states.id`

**Indexes**
- `idx_log_presence_history_changed_at`: ({changed_at})
- `idx_log_presence_history_from_state_id`: ({from_state_id})
- `idx_log_presence_history_source`: ({change_source})
- `idx_log_presence_history_task_context`: ({task_context})
- `idx_log_presence_history_to_state_id`: ({to_state_id})
- `idx_log_presence_history_user`: ({user_id})

### `presence.mst_presence_states`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `code` | character varying | ? |  | - |
| `name` | character varying | ? |  | - |
| `description` | text | - |  | - |
| `category` | character varying | - | 'available'::character varying | - |
| `color` | character varying | - | '#28a745'::character varying | - |
| `icon` | character varying | - |  | - |
| `requires_justification` | boolean | - | false | - |
| `is_temporary_allowed` | boolean | - | false | - |
| `is_active` | boolean | - | true | - |
| `sort_order` | integer | - | 0 | - |
| `created_at` | timestamp with time zone | - | now() | - |
| `updated_at` | timestamp with time zone | - | now() | - |

**Indexes**
- `idx_mst_presence_states_active`: ({is_active})
- `idx_mst_presence_states_category`: ({category})
- `idx_mst_presence_states_code`: ({code})
- `mst_presence_states_code_key` _(unique)_: ({code})

### `presence.trn_user_presence`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `user_id` | uuid | ? |  | - |
| `current_state_id` | uuid | ? |  | - |
| `set_at` | timestamp with time zone | - | now() | - |
| `expires_at` | timestamp with time zone | - |  | - |
| `is_temporary` | boolean | - | false | - |
| `justification` | text | - |  | - |
| `last_activity_at` | timestamp with time zone | - |  | - |
| `last_notification_sent` | timestamp with time zone | - |  | - |
| `created_at` | timestamp with time zone | - | now() | - |
| `updated_at` | timestamp with time zone | - | now() | - |
| `last_task_context_update` | timestamp with time zone | - | now() | - |
| `current_task_id` | uuid | - |  | - |
| `current_project_id` | uuid | - |  | - |

**Relations**
- `current_state_id`  `presence.mst_presence_states.id`

**Indexes**
- `idx_trn_user_presence_current_project`: ({current_project_id})
- `idx_trn_user_presence_current_task`: ({current_task_id})
- `idx_trn_user_presence_expires`: ({expires_at})
- `idx_trn_user_presence_state`: ({current_state_id})
- `idx_trn_user_presence_temporary`: ({is_temporary})
- `idx_trn_user_presence_user`: ({user_id})
- `uk_trn_user_presence_user` _(unique)_: ({user_id})

## `progress`

### `progress.trn_milestones`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `project_id` | uuid | ? |  | - |
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `planned_date` | date | ? |  | - |
| `actual_date` | date | - |  | - |
| `status` | text | ? | 'PENDING'::text | - |
| `is_critical` | boolean | ? | false | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Indexes**
- `idx_trn_milestones_created_by`: ({created_by})
- `idx_trn_milestones_planned_date`: ({planned_date})
- `idx_trn_milestones_project_id`: ({project_id})
- `idx_trn_milestones_status`: ({status})
- `idx_trn_milestones_updated_by`: ({updated_by})

### `progress.trn_progress_updates`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `project_id` | uuid | ? |  | - |
| `task_id` | uuid | - |  | - |
| `user_id` | uuid | ? |  | - |
| `progress_percentage` | numeric | ? |  | - |
| `status` | text | ? |  | - |
| `notes` | text | - |  | - |
| `update_date` | date | ? | CURRENT_DATE | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Indexes**
- `idx_trn_progress_updates_created_by`: ({created_by})
- `idx_trn_progress_updates_project_id`: ({project_id})
- `idx_trn_progress_updates_task_id`: ({task_id})
- `idx_trn_progress_updates_update_date`: ({update_date})
- `idx_trn_progress_updates_updated_by`: ({updated_by})
- `idx_trn_progress_updates_user_id`: ({user_id})

### `progress.trn_project_health`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `project_id` | uuid | ? |  | - |
| `health_score` | numeric | ? |  | - |
| `budget_variance` | numeric | - |  | - |
| `schedule_variance` | integer | - |  | - |
| `quality_score` | numeric | - |  | - |
| `risk_level` | text | ? |  | - |
| `assessment_date` | date | ? | CURRENT_DATE | - |
| `notes` | text | - |  | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Indexes**
- `idx_trn_project_health_assessment_date`: ({assessment_date})
- `idx_trn_project_health_created_by`: ({created_by})
- `idx_trn_project_health_project_id`: ({project_id})
- `idx_trn_project_health_risk_level`: ({risk_level})
- `idx_trn_project_health_updated_by`: ({updated_by})
- `uk_trn_project_health_project_date` _(unique)_: ({project_id,assessment_date})

## `projects`

### `projects.mst_project_stages`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `stage_order` | integer | ? |  | - |
| `project_type_id` | uuid | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `created_by` | uuid | - |  | - |
| `is_active` | boolean | - | true | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |

**Relations**
- `project_type_id`  `projects.mst_project_types.id`

**Indexes**
- `idx_mst_project_stages_created_by`: ({created_by})
- `idx_mst_project_stages_deleted_by`: ({deleted_by})
- `idx_mst_project_stages_updated_by`: ({updated_by})
- `idx_projects_stages_type_order`: ({project_type_id,stage_order})
- `mst_project_stages_project_type_id_name_key` _(unique)_: ({project_type_id,name})
- `mst_project_stages_project_type_id_stage_order_key` _(unique)_: ({project_type_id,stage_order})

### `projects.mst_project_templates`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `project_type_id` | uuid | ? |  | - |
| `default_stages` | jsonb | - | '[]'::jsonb | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `created_by` | uuid | - |  | - |
| `is_active` | boolean | - | true | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |

**Relations**
- `project_type_id`  `projects.mst_project_types.id`

**Indexes**
- `idx_mst_project_templates_created_by`: ({created_by})
- `idx_mst_project_templates_deleted_by`: ({deleted_by})
- `idx_mst_project_templates_updated_by`: ({updated_by})
- `idx_projects_templates_type`: ({project_type_id})
- `mst_project_templates_name_key` _(unique)_: ({name})

### `projects.mst_project_types`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `created_by` | uuid | - |  | - |
| `is_active` | boolean | - | true | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |

**Indexes**
- `idx_mst_project_types_created_by`: ({created_by})
- `idx_mst_project_types_deleted_by`: ({deleted_by})
- `idx_mst_project_types_updated_by`: ({updated_by})
- `idx_projects_types_active`: ({is_active})
- `mst_project_types_name_key` _(unique)_: ({name})

### `projects.trn_projects`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `entity_id` | uuid | ? |  | - |
| `type_id` | uuid | ? |  | - |
| `template_id` | uuid | - |  | - |
| `owner_id` | uuid | ? |  | - |
| `code` | text | ? |  | - |
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `priority` | text | ? |  | - |
| `status` | text | ? | 'DRAFT'::text | - |
| `planned_start_date` | date | ? |  | - |
| `planned_end_date` | date | ? |  | - |
| `actual_start_date` | date | - |  | - |
| `actual_end_date` | date | - |  | - |
| `budget` | numeric | - |  | - |
| `progress_percentage` | numeric | ? | 0.00 | - |
| `current_stage_id` | uuid | - |  | - |
| `config` | jsonb | - |  | - |
| `is_active` | boolean | ? | true | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `budget_responsible_id` | uuid | - |  | - |
| `default_target_margin` | numeric | - |  | - |
| `last_budget_update` | timestamp with time zone | - |  | - |
| `workflow_id` | uuid | - |  | - |
| `workflow_status` | character varying | - | 'not_assigned'::character varying | - |
| `current_stage` | character varying | - |  | - |
| `workflow_assigned_at` | timestamp with time zone | - |  | - |
| `workflow_completed_at` | timestamp with time zone | - |  | - |
| `critical_change_type` | character varying | - |  | - |
| `change_justification` | text | - |  | - |
| `change_requested_by` | uuid | - |  | - |
| `change_requested_at` | timestamp with time zone | - |  | - |
| `discord_channel_id` | uuid | - |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Relations**
- `current_stage_id`  `projects.mst_project_stages.id`
- `template_id`  `projects.mst_project_templates.id`
- `type_id`  `projects.mst_project_types.id`

**Indexes**
- `idx_projects_critical_change_type`: ({critical_change_type})
- `idx_projects_workflow_id`: ({workflow_id})
- `idx_projects_workflow_status`: ({workflow_status})
- `idx_trn_projects_budget_responsible_id`: ({budget_responsible_id})
- `idx_trn_projects_created_at`: ({created_at})
- `idx_trn_projects_current_stage_id`: ({current_stage_id})
- `idx_trn_projects_deleted_null`: ({id})
- `idx_trn_projects_entity_code`: ({entity_id,code})
- `idx_trn_projects_entity_id`: ({entity_id})
- `idx_trn_projects_owner_id`: ({owner_id})
- `idx_trn_projects_status`: ({status})
- `idx_trn_projects_template_id`: ({template_id})
- `idx_trn_projects_type_id`: ({type_id})
- `idx_trn_projects_updated_at`: ({updated_at})
- `uk_trn_projects_entity_code` _(unique)_: ({entity_id,code})

## `realtime`

### `realtime.messages`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `topic` | text | ? |  | - |
| `extension` | text | ? |  | - |
| `payload` | jsonb | - |  | - |
| `event` | text | - |  | - |
| `private` | boolean | - | false | - |
| `updated_at` | timestamp without time zone | ? | now() | - |
| `inserted_at` | timestamp without time zone | ? | now() | ? |
| `id` | uuid | ? | gen_random_uuid() | ? |

### `realtime.schema_migrations`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `version` | bigint | ? |  | ? |
| `inserted_at` | timestamp without time zone | - |  | - |

### `realtime.subscription`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | bigint | ? |  | ? |
| `subscription_id` | uuid | ? |  | - |
| `entity` | regclass | ? |  | - |
| `filters` | ARRAY | ? | '{}'::realtime.user_defined_filter[] | - |
| `claims` | jsonb | ? |  | - |
| `claims_role` | regrole | ? |  | - |
| `created_at` | timestamp without time zone | ? | timezone('utc'::text, now()) | - |

**Indexes**
- `ix_realtime_subscription_entity`: ({entity})
- `subscription_subscription_id_entity_filters_key` _(unique)_: ({subscription_id,entity,filters})

## `storage`

### `storage.buckets`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | text | ? |  | ? |
| `name` | text | ? |  | - |
| `owner` | uuid | - |  | - |
| `created_at` | timestamp with time zone | - | now() | - |
| `updated_at` | timestamp with time zone | - | now() | - |
| `public` | boolean | - | false | - |
| `avif_autodetection` | boolean | - | false | - |
| `file_size_limit` | bigint | - |  | - |
| `allowed_mime_types` | ARRAY | - |  | - |
| `owner_id` | text | - |  | - |

**Indexes**
- `bname` _(unique)_: ({name})

### `storage.migrations`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | integer | ? |  | ? |
| `name` | character varying | ? |  | - |
| `hash` | character varying | ? |  | - |
| `executed_at` | timestamp without time zone | - | CURRENT_TIMESTAMP | - |

**Indexes**
- `migrations_name_key` _(unique)_: ({name})

### `storage.objects`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `bucket_id` | text | - |  | - |
| `name` | text | - |  | - |
| `owner` | uuid | - |  | - |
| `created_at` | timestamp with time zone | - | now() | - |
| `updated_at` | timestamp with time zone | - | now() | - |
| `last_accessed_at` | timestamp with time zone | - | now() | - |
| `metadata` | jsonb | - |  | - |
| `path_tokens` | ARRAY | - |  | - |
| `version` | text | - |  | - |
| `owner_id` | text | - |  | - |
| `user_metadata` | jsonb | - |  | - |

**Indexes**
- `bucketid_objname` _(unique)_: ({bucket_id,name})
- `idx_objects_bucket_id_name`: ({bucket_id,name})
- `name_prefix_search`: ({name})

### `storage.s3_multipart_uploads`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | text | ? |  | ? |
| `in_progress_size` | bigint | ? | 0 | - |
| `upload_signature` | text | ? |  | - |
| `bucket_id` | text | ? |  | - |
| `key` | text | ? |  | - |
| `version` | text | ? |  | - |
| `owner_id` | text | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `user_metadata` | jsonb | - |  | - |

**Indexes**
- `idx_multipart_uploads_list`: ({bucket_id,key,created_at})

### `storage.s3_multipart_uploads_parts`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `upload_id` | text | ? |  | - |
| `size` | bigint | ? | 0 | - |
| `part_number` | integer | ? |  | - |
| `bucket_id` | text | ? |  | - |
| `key` | text | ? |  | - |
| `etag` | text | ? |  | - |
| `owner_id` | text | - |  | - |
| `version` | text | ? |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |

## `tasks`

### `tasks.mst_task_stages`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `stage_order` | integer | ? |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `created_by` | uuid | - |  | - |
| `is_active` | boolean | - | true | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Indexes**
- `idx_mst_task_stages_created_by`: ({created_by})
- `idx_mst_task_stages_deleted_by`: ({deleted_by})
- `idx_mst_task_stages_deleted_null`: ({id})
- `idx_mst_task_stages_updated_by`: ({updated_by})
- `idx_tasks_stages_order`: ({stage_order})
- `mst_task_stages_name_key` _(unique)_: ({name})
- `mst_task_stages_stage_order_key` _(unique)_: ({stage_order})

### `tasks.mst_task_types`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | text | ? |  | - |
| `description` | text | - |  | - |
| `dedication_type` | text | - |  | - |
| `created_at` | timestamp with time zone | ? | now() | - |
| `updated_at` | timestamp with time zone | ? | now() | - |
| `created_by` | uuid | - |  | - |
| `is_active` | boolean | - | true | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Indexes**
- `idx_mst_task_types_created_by`: ({created_by})
- `idx_mst_task_types_deleted_by`: ({deleted_by})
- `idx_mst_task_types_deleted_null`: ({id})
- `idx_mst_task_types_updated_by`: ({updated_by})
- `idx_tasks_types_active`: ({is_active})
- `mst_task_types_name_key` _(unique)_: ({name})

### `tasks.rel_task_assignments`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `task_id` | uuid | ? |  | - |
| `user_id` | uuid | ? |  | - |
| `assigned_by` | uuid | ? |  | - |
| `assigned_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `is_active` | boolean | ? | true | - |
| `role` | text | ? | 'ASSIGNEE'::text | - |
| `created_by` | uuid | - |  | - |
| `updated_by` | uuid | - |  | - |
| `deleted_by` | uuid | - |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Relations**
- `task_id`  `tasks.trn_tasks.id`

**Indexes**
- `idx_rel_task_assignments_active`: ({is_active})
- `idx_rel_task_assignments_assigned_by`: ({assigned_by})
- `idx_rel_task_assignments_created_by`: ({created_by})
- `idx_rel_task_assignments_deleted_by`: ({deleted_by})
- `idx_rel_task_assignments_task_id`: ({task_id})
- `idx_rel_task_assignments_updated_by`: ({updated_by})
- `idx_rel_task_assignments_user_id`: ({user_id})
- `uk_rel_task_assignments_task_user` _(unique)_: ({task_id,user_id})

### `tasks.trn_task_time_records`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `user_id` | uuid | ? |  | - |
| `project_id` | uuid | - |  | - |
| `task_id` | uuid | - |  | - |
| `entry_date` | date | ? |  | - |
| `entry_type` | text | ? |  | - |
| `start_time` | time without time zone | - |  | - |
| `end_time` | time without time zone | - |  | - |
| `hours_worked` | numeric | - |  | - |
| `description` | text | - |  | - |
| `is_billable` | boolean | - | true | - |
| `status` | text | - | 'DRAFT'::text | - |
| `break_type` | text | - |  | - |
| `break_category` | text | - | 'rest'::text | - |
| `duration_minutes` | integer | - |  | - |
| `break_notes` | text | - |  | - |
| `approval_action` | text | - |  | - |
| `approval_comments` | text | - |  | - |
| `approved_at` | timestamp with time zone | - |  | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `budget_allocation` | numeric | - |  | - |
| `cost_category` | text | - |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Relations**
- `task_id`  `tasks.trn_tasks.id`

**Indexes**
- `idx_trn_task_time_records_project_id`: ({project_id})
- `idx_trn_task_time_records_task_id`: ({task_id})
- `idx_trn_task_time_records_user_id`: ({user_id})

### `tasks.trn_tasks`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `project_id` | uuid | ? |  | - |
| `type_id` | uuid | ? |  | - |
| `parent_task_id` | uuid | - |  | - |
| `title` | text | ? |  | - |
| `description` | text | - |  | - |
| `priority` | text | ? | 'MEDIUM'::text | - |
| `estimated_hours` | numeric | - |  | - |
| `actual_hours` | numeric | - | 0 | - |
| `progress_percentage` | numeric | - | 0.00 | - |
| `planned_start_date` | date | - |  | - |
| `planned_end_date` | date | - |  | - |
| `actual_start_date` | date | - |  | - |
| `actual_end_date` | date | - |  | - |
| `is_active` | boolean | ? | true | - |
| `created_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | - | CURRENT_TIMESTAMP | - |
| `created_by` | uuid | ? |  | - |
| `updated_by` | uuid | ? |  | - |
| `stage_id` | uuid | ? |  | - |
| `workflow_id` | uuid | - |  | - |
| `workflow_status` | character varying | - | 'not_assigned'::character varying | - |
| `current_stage` | character varying | - |  | - |
| `workflow_assigned_at` | timestamp with time zone | - |  | - |
| `workflow_completed_at` | timestamp with time zone | - |  | - |
| `criticality_level` | character varying | - | 'normal'::character varying | - |
| `assignment_change_type` | character varying | - |  | - |
| `assignment_justification` | text | - |  | - |
| `assignment_requested_by` | uuid | - |  | - |
| `assignment_requested_at` | timestamp with time zone | - |  | - |
| `deleted_at` | timestamp with time zone | - |  | - |

**Relations**
- `parent_task_id`  `tasks.trn_tasks.id`
- `type_id`  `tasks.mst_task_types.id`
- `stage_id`  `tasks.mst_task_stages.id`

**Indexes**
- `idx_tasks_assignment_change_type`: ({assignment_change_type})
- `idx_tasks_criticality_level`: ({criticality_level})
- `idx_tasks_workflow_id`: ({workflow_id})
- `idx_tasks_workflow_status`: ({workflow_status})
- `idx_trn_tasks_created_by`: ({created_by})
- `idx_trn_tasks_parent_task_id`: ({parent_task_id})
- `idx_trn_tasks_priority`: ({priority})
- `idx_trn_tasks_project_id`: ({project_id})
- `idx_trn_tasks_stage_id`: ({stage_id})
- `idx_trn_tasks_type_id`: ({type_id})
- `idx_trn_tasks_updated_by`: ({updated_by})

## `vault`

### `vault.secrets`

| Column | Type | Req | Default | PK |
|---|---|---|---|---|
| `id` | uuid | ? | gen_random_uuid() | ? |
| `name` | text | - |  | - |
| `description` | text | ? | ''::text | - |
| `secret` | text | ? |  | - |
| `key_id` | uuid | - |  | - |
| `nonce` | bytea | - | vault._crypto_aead_det_noncegen() | - |
| `created_at` | timestamp with time zone | ? | CURRENT_TIMESTAMP | - |
| `updated_at` | timestamp with time zone | ? | CURRENT_TIMESTAMP | - |

**Indexes**
- `secrets_name_idx` _(unique)_: ({name})
