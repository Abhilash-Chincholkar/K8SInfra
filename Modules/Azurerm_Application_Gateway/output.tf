output "application_gateway_id" {
  value = {
    for k, v in azurerm_application_gateway.agw :
    k => v.id
  }
}

output "agw_resource_group_id" {
  value = data.azurerm_resource_group.agw_rg.id
}