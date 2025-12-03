# Terraform backend configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  # Backend config is supplied via `terraform init -backend-config` flags
  backend "gcs" {
    bucket = "hiroaki-u-terraform-state"
    prefix = "n8n"
  }
}
