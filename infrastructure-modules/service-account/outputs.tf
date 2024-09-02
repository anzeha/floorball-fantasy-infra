
output "service_account_key" {
  value = google_service_account_key.this.private_key
  sensitive = true
}