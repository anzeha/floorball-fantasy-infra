terraform {
  source = "git::https://github.com/anzeha/infra-modules.git//kubernetes-addons?ref=v0.0.4"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}


dependency "cluster" {
  config_path = "../cluster"
  mock_outputs = {
    cluster_ca_certificate = "sample-ceritifcate"
    host                   = "sample-host"
    token                  = "token"
    cluster_name           = "sample-name"
  }
}


generate "kubernetes_provider" {
  path      = "kubernetes-provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "kubernetes" {
  cluster_ca_certificate = base64decode("${dependency.eks_cluster.outputs.cluster_ca_certificate}")
  host                   = "${dependency.eks_cluster.outputs.host}"
  token                  = "${dependency.eks_cluster.outputs.token}"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}
provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode("${dependency.eks_cluster.outputs.cluster_ca_certificate}")
    host                   = "${dependency.eks_cluster.outputs.host}"
    token                  = "${dependency.eks_cluster.outputs.token}"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}
EOF
}

locals {
  env = include.env.locals.env
}

inputs = {
  env        = local.env
  project_id = include.root.locals.project_id

  cluster_name = dependency.cluster.outputs.cluster_name

  create_app_namespace = true
  app_namespace        = include.root.locals.app_namespace
}
