resource "azurerm_virtual_network" "virtual_network" {
  for_each            = var.virtual_network
  name                = each.value.vnet_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space


  dynamic "subnet" {
    for_each = varvirtual_network.subnets
    content {
      name             = subnet.value.subnet_name
      address_prefixes = subnet.address_prefixes
    }
  }

  tags = each.value.tags
}
