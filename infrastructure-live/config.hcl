locals {
  project_id      = "floorball-fantasy"
  region          = "europe-west4"
  bucket_name     = "${local.project_id}-bucket"
  resource_prefix = "ffantasy"
  app_namespace   = "floorball-fantasy"
  cicd_project_id = "deployment-433913"
}
