resource "azurerm_public_ip" "public_ip" {
  for_each            = var.pips
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method

  tags = each.value.tags
}
