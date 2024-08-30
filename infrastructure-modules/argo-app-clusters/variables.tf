variable "clusters" {
  description = "A list of clusters with their respective bearerToken, name, and server."
  type = list(object({
    bearerToken = string
    name        = string
    server      = string
  }))
}