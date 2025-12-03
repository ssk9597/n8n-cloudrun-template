# Standalone stack for Secret Manager resources only

// backend と required_providers は backend.tf に定義

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Secret Manager secrets (boxes)
resource "google_secret_manager_secret" "n8n_db_host" {
  secret_id = var.db_host_secret_id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret" "n8n_db_user" {
  secret_id = var.db_user_secret_id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret" "n8n_db_password" {
  secret_id = var.db_password_secret_id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret" "n8n_encryption_key" {
  secret_id = var.encryption_key_secret_id

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

# Generate ephemeral random encryption key for n8n
resource "random_password" "n8n_encryption_key" {
  length  = 32
  special = true
}

resource "google_secret_manager_secret_version" "n8n_encryption_key" {
  secret      = google_secret_manager_secret.n8n_encryption_key.id
  secret_data = resource.random_password.n8n_encryption_key.result
}

# Initial versions (optional) for DB secrets from tfvars/env
resource "google_secret_manager_secret_version" "n8n_db_host" {
  count       = var.initial_db_host == null ? 0 : 1
  secret      = google_secret_manager_secret.n8n_db_host.id
  secret_data = var.initial_db_host
}

resource "google_secret_manager_secret_version" "n8n_db_user" {
  count       = var.initial_db_user == null ? 0 : 1
  secret      = google_secret_manager_secret.n8n_db_user.id
  secret_data = var.initial_db_user
}

resource "google_secret_manager_secret_version" "n8n_db_password" {
  count       = var.initial_db_password == null ? 0 : 1
  secret      = google_secret_manager_secret.n8n_db_password.id
  secret_data = var.initial_db_password
}
