# Variables for secrets stack

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "zone" {
  description = "The GCP zone"
  type        = string
}

variable "initial_db_host" {
  description = "Optional initial DB host"
  type        = string
  default     = null
}

variable "initial_db_user" {
  description = "Optional initial DB user"
  type        = string
  default     = null
}

variable "initial_db_password" {
  description = "Optional initial DB password"
  type        = string
  default     = null
}

variable "db_host_secret_id" {
  description = "Secret Manager secret ID for database host"
  type        = string
  default     = "n8n-db-host"
}

variable "db_user_secret_id" {
  description = "Secret Manager secret ID for database user"
  type        = string
  default     = "n8n-db-user"
}

variable "db_password_secret_id" {
  description = "Secret Manager secret ID for database password"
  type        = string
  default     = "n8n-db-password"
}

variable "encryption_key_secret_id" {
  description = "Secret Manager secret ID for n8n encryption key"
  type        = string
  default     = "n8n-encryption-key"
}


