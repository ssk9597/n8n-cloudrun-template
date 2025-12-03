# Variables for cloud-run module

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "n8n-service"
}

variable "n8n_image" {
  description = "Docker image for n8n"
  type        = string
  default     = "n8nio/n8n:latest"
}

variable "cpu_limit" {
  description = "CPU limit for the container"
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit for the container"
  type        = string
  default     = "1Gi"
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated access to the service"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "timezone" {
  description = "Timezone for n8n"
  type        = string
  default     = "Asia/Tokyo"
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "postgres"
}

variable "database_port" {
  description = "Database port"
  type        = string
  default     = "6543"
}

variable "database_schema" {
  description = "Database schema"
  type        = string
  default     = "public"
}

# Secret Manager secret IDs
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

variable "storage_bucket_name" {
  description = "Name of the Cloud Storage bucket for file storage"
  type        = string
}

# Optional: These can be set after first apply when the service URL is known
variable "n8n_host" {
  description = "Hostname for N8N_HOST (e.g., n8n-xxxx.a.run.app)"
  type        = string
  default     = null
}

variable "n8n_editor_base_url" {
  description = "Full editor base URL for N8N_EDITOR_BASE_URL (e.g., https://...)"
  type        = string
  default     = null
}
