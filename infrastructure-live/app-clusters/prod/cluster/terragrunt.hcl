terraform {
  source = "../../../../infrastructure-modules/cluster"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {

  env        = local.environment_vars.locals.env
  project_id = include.root.locals.project_id

  resource_prefix = include.root.locals.config_vars.locals.resource_prefix

  network    = dependency.vpc.outputs.vpc_network_name
  subnetwork = dependency.vpc.outputs.vpc_subnetwork_name


}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_network_name    = "example-network"
    vpc_subnetwork_name = "example-subnetwork"
  }
}