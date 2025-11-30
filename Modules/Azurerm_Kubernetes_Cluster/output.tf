output "kubernetes_cluster_id" {
  value = { for k, v in azurerm_kubernetes_cluster.kubernetes_cluster : k => v.id }
}

output "kubelet_identity" {
  value = { for k, v in azurerm_kubernetes_cluster.kubernetes_cluster : k => v.kubelet_identity[0] }
}

output "kubelet_identity_ids" {
  value = { for k, v in azurerm_kubernetes_cluster.kubernetes_cluster : k => v.kubelet_identity[0].object_id }
}

output "kubernetes_principal_id" {
  value = { for k, v in azurerm_kubernetes_cluster.kubernetes_cluster : k => v.identity[0].principal_id }
}