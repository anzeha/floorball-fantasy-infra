resource "google_compute_address" "ingress" {
  count = var.deploy_nginx ? 1 : 0
  name    = format("%s-%s-ingress-ip", var.cluster_name, var.env)
  project = var.project_id
  region  = var.region
}

resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "terraform-example-namespace"
  }
}


# module "nginx-controller" {
#   count = var.deploy_nginx ? 1 : 0
#   source = "terraform-iaac/nginx-controller/helm"

#   ip_address = google_compute_address.ingress[0].address

# }