# Outputs for storage module

output "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  value       = google_storage_bucket.n8n_files.name
}

output "bucket_url" {
  description = "URL of the Cloud Storage bucket"
  value       = google_storage_bucket.n8n_files.url
}

output "bucket_self_link" {
  description = "Self link of the Cloud Storage bucket"
  value       = google_storage_bucket.n8n_files.self_link
}
