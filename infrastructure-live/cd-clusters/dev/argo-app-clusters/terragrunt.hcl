terraform {
  source = "../../../../infrastructure-modules/argo-app-clusters"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "eks_cluster_self" {
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
  cluster_ca_certificate = base64decode("${dependency.eks_cluster_self.outputs.cluster_ca_certificate}")
  host                   = "${dependency.eks_cluster_self.outputs.host}"
  token                  = "${dependency.eks_cluster_self.outputs.token}"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}
provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode("${dependency.eks_cluster_self.outputs.cluster_ca_certificate}")
    host                   = "${dependency.eks_cluster_self.outputs.host}"
    token                  = "${dependency.eks_cluster_self.outputs.token}"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}
EOF
}


inputs = {
  clusters = [
    {
      bearerToken = "${dependency.service_account.outputs.service_account_key}"
      name        = "${dependency.app_cluster_staging.outputs.cluster_name}"
      server      = "${dependency.app_cluster_staging.outputs.host}"
    },
  ]
}

dependency "service_account" {
  config_path = "../../../../infrastructure-live/app-clusters/service-account"
  mock_outputs = {
    service_account_key        = "sample-service-account-key"
  }
}

####################################
#  Dependencies for app clusters   #
####################################
dependency "app_cluster_staging" {
  config_path = "../../../../infrastructure-live/app-clusters/staging/cluster"
  mock_outputs = {
    cluster_name        = "sample-cluster-name"
    host                = "sample-host"
    service_account_key = "exmaple-service-account-key"
  }
}