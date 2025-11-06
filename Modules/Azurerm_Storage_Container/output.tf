output "container_id" {
  value       = { for key, container in azurerm_storage_container.storage_container : key => container.id }
  description = "Map of container IDs"
}