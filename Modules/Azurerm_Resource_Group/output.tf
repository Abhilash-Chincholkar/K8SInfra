output "rg-id" {
    value = {for key,rg in azurerm_resource_group.resource_group: key => rg.id }
    description = "resource group id"
}