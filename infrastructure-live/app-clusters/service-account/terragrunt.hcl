terraform {
  source = "../../../infrastructure-modules/service-account"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  project_id      = include.root.locals.project_id
}

inputs = {
  project_id = local.project_id
}

