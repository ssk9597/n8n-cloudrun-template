// Variables for app layer (Cloud Run)

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
}

variable "n8n_image" {
  description = "Docker image for n8n"
  type        = string
}

variable "cpu_limit" {
  description = "CPU limit for the Cloud Run container"
  type        = string
}

variable "memory_limit" {
  description = "Memory limit for the Cloud Run container"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of Cloud Run instances"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of Cloud Run instances"
  type        = number
}

variable "db_host_secret_id" {
  description = "Secret Manager secret ID for database host"
  type        = string
}

variable "db_user_secret_id" {
  description = "Secret Manager secret ID for database user"
  type        = string
}

variable "db_password_secret_id" {
  description = "Secret Manager secret ID for database password"
  type        = string
}

variable "encryption_key_secret_id" {
  description = "Secret Manager secret ID for n8n encryption key"
  type        = string
}

variable "database_schema" {
  description = "Database schema for n8n tables"
  type        = string
}

variable "n8n_host" {
  description = "Hostname for N8N_HOST"
  type        = string
  default     = null
}

variable "n8n_editor_base_url" {
  description = "Editor base URL for N8N_EDITOR_BASE_URL"
  type        = string
  default     = null
}

variable "storage_bucket_name" {
  description = "Bucket name for n8n file storage"
  type        = string
}


