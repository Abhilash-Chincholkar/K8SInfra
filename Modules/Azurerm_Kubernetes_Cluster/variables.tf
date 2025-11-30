variable "kubernetes_clusters" {
    type = map(object({
        name                = string
        location            = string
        resource_group_name = string
        dns_prefix          = string
        node_pools = list(object({
            name       = string
            node_count = number
            vm_size    = string
        }))
        identity = list(object({
            type = string
        }))
        tags = map(string)
    }))
    description = "Map of Kubernetes clusters to create"
}

variable "acr_id" {
  type        = string
  description = "ACR resource ID to grant AKS pull access (e.g. /subscriptions/.../resourceGroups/.../providers/Microsoft.ContainerRegistry/registries/...)"
}
variable "application_gateway_id" {
  type        = string
  description = "(Optional) AGW resource ID for AGIC addon"
  default     = ""
}
