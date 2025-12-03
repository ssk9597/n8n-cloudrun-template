# Outputs for cloud-run module

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.n8n.name
}

output "service_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_service.n8n.status[0].url
}

output "service_account_email" {
  description = "Email of the service account used by the Cloud Run service"
  value       = google_service_account.n8n_service_account.email
}

output "service_location" {
  description = "Location of the Cloud Run service"
  value       = google_cloud_run_service.n8n.location
}
