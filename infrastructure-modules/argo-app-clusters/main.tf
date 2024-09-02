# Convert the list to a map
locals {
  clusters_map = { for cluster in var.clusters : cluster.name => cluster }
}

resource "kubernetes_secret" "gke_cluster" {
  for_each = local.clusters_map
  metadata {
    name      = "${each.value.name}-secret"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" : "cluster"
    }
  }

  type = "Opaque"

  data = {
    config = jsonencode({
      bearerToken = each.value.bearerToken,
      tlsClientConfig = {
        insecure = true,
      }
    })
    name   = each.value.name
    server = each.value.server
  }
}