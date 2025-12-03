# Cloud Storage module for n8n

# Cloud Storage bucket for n8n file storage
resource "google_storage_bucket" "n8n_files" {
  name                        = "${var.project_id}-n8n-files-${var.suffix}"
  location                    = var.region
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  labels = {
    component = "n8n-storage"
  }
}
