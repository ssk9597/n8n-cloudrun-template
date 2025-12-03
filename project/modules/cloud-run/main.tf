# Cloud Run module for n8n

# Service account for Cloud Run
resource "google_service_account" "n8n_service_account" {
  account_id   = "n8n-service-account"
  display_name = "n8n Cloud Run Service Account"
  description  = "Service account for n8n Cloud Run service"
}

# IAM bindings for the service account
resource "google_project_iam_member" "n8n_storage_access" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.n8n_service_account.email}"
}

resource "google_project_iam_member" "n8n_secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.n8n_service_account.email}"
}

# Cloud Run service for n8n
resource "google_cloud_run_service" "n8n" {
  name     = var.service_name
  location = var.region
  depends_on = [
    google_project_iam_member.n8n_secret_access,
    google_project_iam_member.n8n_storage_access
  ]

  template {
    spec {
      service_account_name = google_service_account.n8n_service_account.email

      containers {
        image = var.n8n_image

        ports {
          name           = "http1"
          container_port = 5678
        }

        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
          requests = {
            cpu    = "500m"
            memory = "256Mi"
          }
        }


        env {
          name  = "DB_TYPE"
          value = "postgresdb"
        }

        env {
          name = "DB_POSTGRESDB_HOST"
          value_from {
            secret_key_ref {
              name = var.db_host_secret_id
              key  = "latest"
            }
          }
        }

        env {
          name  = "DB_LOGGING_ENABLED"
          value = "true"
        }

        env {
          name = "DB_POSTGRESDB_USER"
          value_from {
            secret_key_ref {
              name = var.db_user_secret_id
              key  = "latest"
            }
          }
        }

        env {
          name = "DB_POSTGRESDB_PASSWORD"
          value_from {
            secret_key_ref {
              name = var.db_password_secret_id
              key  = "latest"
            }
          }
        }

        env {
          name  = "DB_POSTGRESDB_DATABASE"
          value = var.database_name
        }

        env {
          name  = "DB_POSTGRESDB_PORT"
          value = var.database_port
        }

        env {
          name  = "DB_POSTGRESDB_SCHEMA"
          value = var.database_schema
        }

        env {
          name = "N8N_ENCRYPTION_KEY"
          value_from {
            secret_key_ref {
              name = var.encryption_key_secret_id
              key  = "latest"
            }
          }
        }

        env {
          name  = "N8N_PROTOCOL"
          value = "https"
        }

        dynamic "env" {
          for_each = var.n8n_host == null ? [] : [var.n8n_host]
          content {
            name  = "N8N_HOST"
            value = env.value
          }
        }

        dynamic "env" {
          for_each = var.n8n_editor_base_url == null ? [] : [var.n8n_editor_base_url]
          content {
            name  = "N8N_EDITOR_BASE_URL"
            value = env.value
          }
        }

        env {
          name  = "N8N_LISTEN_ADDRESS"
          value = "0.0.0.0"
        }

        env {
          name  = "GENERIC_TIMEZONE"
          value = var.timezone
        }

        env {
          name  = "N8N_METRICS"
          value = "false"
        }

        env {
          name  = "N8N_DIAGNOSTICS_ENABLED"
          value = "false"
        }

        env {
          name  = "N8N_DEFAULT_BINARY_DATA_MODE"
          value = "filesystem"
        }

        env {
          name  = "N8N_BINARY_DATA_STORAGE_PATH"
          value = "/tmp/n8n-binary-data"
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"         = tostring(var.max_instances)
        "autoscaling.knative.dev/minScale"         = tostring(var.min_instances)
        "run.googleapis.com/cpu-throttling"        = "true"
        "run.googleapis.com/execution-environment" = "gen2"
        "run.googleapis.com/startup-timeout"       = "1800s"
      }

      labels = {
        environment = var.environment
        component   = "n8n-app"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Allow unauthenticated access to Cloud Run service
resource "google_cloud_run_service_iam_member" "public_access" {
  count = var.allow_unauthenticated ? 1 : 0

  service  = google_cloud_run_service.n8n.name
  location = google_cloud_run_service.n8n.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
