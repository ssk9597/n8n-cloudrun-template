// App layer: n8n Cloud Run service

module "cloud_run" {
  source = "../../modules/cloud-run"

  project_id   = var.project_id
  region       = var.region
  service_name = "n8n-service"
  n8n_image    = var.n8n_image

  # Optional host values (may be set on second apply)
  n8n_host            = var.n8n_host
  n8n_editor_base_url = var.n8n_editor_base_url

  # Resource limits
  cpu_limit     = var.cpu_limit
  memory_limit  = var.memory_limit
  min_instances = var.min_instances
  max_instances = var.max_instances

  # Secret Manager references
  db_host_secret_id        = var.db_host_secret_id
  db_user_secret_id        = var.db_user_secret_id
  db_password_secret_id    = var.db_password_secret_id
  encryption_key_secret_id = var.encryption_key_secret_id

  # Database schema
  database_schema = var.database_schema

  # Storage reference
  storage_bucket_name = var.storage_bucket_name
}


