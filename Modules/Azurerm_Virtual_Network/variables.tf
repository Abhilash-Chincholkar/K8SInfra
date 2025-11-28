variable "virtual_network" {
  type = map(object({
    vnet_name           = string
    location            = string
    resource_group_name = string
    address_space       = string
    subnets = map(object({
      subnet_name      = string
      address_prefixes = string
    }))
    tags = map(string)
  }))
}
