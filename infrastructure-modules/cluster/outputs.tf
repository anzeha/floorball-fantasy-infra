output "cluster_ca_certificate" {
  # value = base64encode(data.google_container_cluster.gke.master_auth.0.cluster_ca_certificate)
  value = base64encode(module.gke_auth.cluster_ca_certificate)
  sensitive = true
}

output "host" {
  value = data.google_container_cluster.gke.endpoint
  sensitive = true
}

output "token" {
  value = data.google_client_config.provider.access_token
  sensitive = true
}