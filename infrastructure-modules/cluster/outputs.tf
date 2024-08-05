output "cluster_ca_certificate" {
  value = module.gke.ca_certificate
  sensitive = true
}

output "host" {
  value = module.gke.endpoint
  sensitive = true
}

output "token" {
  value = data.google_client_config.provider.access_token
  sensitive = true
}