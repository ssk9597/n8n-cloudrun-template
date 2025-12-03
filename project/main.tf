# n8n on GCP Cloud Run + Supabase
# Main Terraform configuration using modules

# Configure the Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Network/storage layer
module "network" {
  source = "./infra/network"

  project_id = var.project_id
  region     = var.region
}

# App layer (n8n Cloud Run)
module "app" {
  source = "./infra/app"

  project_id = var.project_id
  region     = var.region

  n8n_image   = var.n8n_image
  cpu_limit   = var.cpu_limit
  memory_limit  = var.memory_limit
  min_instances = var.min_instances
  max_instances = var.max_instances

  db_host_secret_id        = var.db_host_secret_id
  db_user_secret_id        = var.db_user_secret_id
  db_password_secret_id    = var.db_password_secret_id
  encryption_key_secret_id = var.encryption_key_secret_id

  database_schema = var.database_schema

  n8n_host            = var.n8n_host
  n8n_editor_base_url = var.n8n_editor_base_url

  storage_bucket_name = module.network.bucket_name

  depends_on = [
    module.network
  ]
}

