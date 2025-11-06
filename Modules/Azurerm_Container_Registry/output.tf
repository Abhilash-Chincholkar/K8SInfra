output "acr_id" {
  value = { for key, acr in azurerm_container_registry.acr : key => acr.id }
}