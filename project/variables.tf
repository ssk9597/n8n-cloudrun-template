# Variables for n8n Terraform configuration

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "asia-northeast1"
}

variable "zone" {
  description = "The GCP zone for resources"
  type        = string
  default     = "asia-northeast1-a"
}

variable "n8n_image" {
  description = "Docker image for n8n"
  type        = string
  default     = "n8nio/n8n:latest"
}

# Cloud Run configuration
variable "cpu_limit" {
  description = "CPU limit for the Cloud Run container"
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit for the Cloud Run container"
  type        = string
  default     = "512Mi"
}

variable "min_instances" {
  description = "Minimum number of Cloud Run instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of Cloud Run instances"
  type        = number
  default     = 3
}

# Secret Manager secret IDs (names). Provided via tfvars or environment.
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
  default     = "public"
}

# Optional: These are populated on the second apply using the discovered service URL
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
