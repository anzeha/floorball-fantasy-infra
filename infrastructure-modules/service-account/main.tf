resource "google_service_account" "this" {
  account_id                   = "argo-service-account"
  display_name                 = "argocd service account"
  create_ignore_already_exists = true
}

# Define IAM roles to be granted
resource "google_project_iam_member" "this" {
  for_each = toset([
    "roles/iam.serviceAccountAdmin",
    "roles/container.clusterAdmin",
    "roles/container.developer",
    "roles/editor",
    "roles/owner",
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.this.email}"
}

# Create a key for the service account
resource "google_service_account_key" "this" {
  service_account_id = google_service_account.this.email
  key_algorithm      = "KEY_ALG_RSA_2048"
  public_key_type    = "TYPE_RAW_PUBLIC_KEY"
}