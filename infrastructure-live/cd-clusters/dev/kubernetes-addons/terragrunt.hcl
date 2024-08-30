terraform{
    source = "../../../../infrastructure-modules/kubernetes-addons"
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}


dependency "eks_cluster_self" {
    config_path = "../cluster"
     mock_outputs = {
       cluster_ca_certificate = "sample-ceritifcate"
       host = "sample-host"
       token = "token"
       cluster_name = "sample-name"
     }
}

// dependency "eks_cluster_staging" {
//   config_path = "../../../../infrastructure-live/app-clusters/staging/vpc"
//     mock_outputs = {
//       service_account_key = "sample-account-key"
//     }
// }


generate "kubernetes_provider" {
  path = "kubernetes-provider.tf"
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
    env = include.root.locals.environment_vars.locals.env
    project_id = include.root.locals.project_id

    cluster_name = dependency.eks_cluster_self.outputs.cluster_name
}