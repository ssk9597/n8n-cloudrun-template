// App layer outputs

output "service_url" {
  description = "URL of the Cloud Run service"
  value       = module.cloud_run.service_url
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = module.cloud_run.service_name
}


