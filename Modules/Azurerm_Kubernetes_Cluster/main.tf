resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  for_each            = var.kubernetes_clusters
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix

  dynamic "default_node_pool" {
    for_each = each.value.node_pools
    content {
      name       = default_node_pool.value.name
      node_count = default_node_pool.value.node_count
      vm_size    = default_node_pool.value.vm_size
    }
  }

  dynamic "identity" {
    for_each = each.value.identity
    content {
      type = identity.value.type
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = var.application_gateway_id != "" ? [1] : []
    content {
      gateway_id = var.application_gateway_id
    }
  }
  
  tags = each.value.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  for_each = azurerm_kubernetes_cluster.kubernetes_cluster

  principal_id                     = each.value.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}
