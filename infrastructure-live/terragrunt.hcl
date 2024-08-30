remote_state {
  backend = "gcs"

  generate = {
    path      = "state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    prefix = "${path_relative_to_include()}/terraform.tfstate"
    bucket   = local.bucket_name
    project  = local.bucket_project_id
    location = local.bucket_region
  }

}

locals{
//   config_vars = read_terragrunt_config("${get_parent_terragrunt_dir()}/config.hcl") 
  config_vars = read_terragrunt_config(find_in_parent_folders("config.hcl"))

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  bucket_vars = read_terragrunt_config(find_in_parent_folders("bucket.hcl"))

  # Extract the variables we need for easy access
  bucket_region = local.bucket_vars.locals.region
  bucket_project_id   = local.bucket_vars.locals.project_id
  bucket_name = local.bucket_vars.locals.name

  # project_id is not the same as bucket_project_id
  project_id = local.config_vars.locals.project_id
  region = local.config_vars.locals.region
}


generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "google" {
  region  = "${local.region}"
  project = "${local.project_id}"
}
data "google_client_config" "default" {}
EOF
}
