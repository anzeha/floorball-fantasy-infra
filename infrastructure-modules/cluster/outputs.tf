output "cluster_ca_certificate" {
  value = module.gke_auth.cluster_ca_certificate
  sensitive = true
}

output "host" {
  value = module.gke_auth.host
  sensitive = true
}

output "token" {
  value = data.google_client_config.provider.access_token
  sensitive = true
}