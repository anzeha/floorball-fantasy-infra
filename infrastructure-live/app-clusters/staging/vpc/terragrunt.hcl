terraform{
    source = "../../../../infrastructure-modules/vpc"
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

locals{
    env = include.root.locals.environment_vars.locals.env
    project_id = include.root.locals.project_id
    resource_prefix = include.root.locals.config_vars.locals.resource_prefix
    create_service_accounts = include.root.locals.config_vars.locals.is_project_resource
}

inputs = {
    env            = local.env
    project_id     = local.project_id

    resource_prefix = local.resource_prefix
    create_service_accounts = local.create_service_accounts
}

