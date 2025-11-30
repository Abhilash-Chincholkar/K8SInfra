data "azurerm_subnet" "datasubnet" {
  for_each = var.agw
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "datapublic_ip" {
  for_each = var.agw
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_resource_group" "agw_rg" {
  name = var.agw["ag1"].resource_group_name
}
