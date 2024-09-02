resource "google_service_account" "this" {
    count = var.create_service_account ? 1: 0
  account_id   = "argo-service-account"
  display_name = "argocd service account"
}

# Define IAM roles to be granted
resource "google_project_iam_member" "this" {
  for_each = var.create_service_account ? toset([
    "roles/iam.serviceAccountAdmin",
    "roles/container.clusterAdmin",
    "roles/container.developer",
    "roles/editor",
    "roles/owner",
  ]) : []

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.this[0].email}"
}

# Create a key for the service account
resource "google_service_account_key" "this" {
    count = var.create_service_account ? 1: 0
  service_account_id = google_service_account.this[0].email
  key_algorithm      = "KEY_ALG_RSA_2048"
  public_key_type = "TYPE_RAW_PUBLIC_KEY"
}