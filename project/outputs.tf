# Project-level outputs to expose layer/module values

output "service_url" {
  description = "URL of the Cloud Run service"
  value       = module.app.service_url
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = module.app.service_name
}

output "bucket_name" {
  description = "Bucket name for n8n file storage"
  value       = module.network.bucket_name
}

