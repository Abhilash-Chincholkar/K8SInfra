variable "acr" {
  type = map(object(
    {
      resource_group_name = string
      location            = string
      name                = string
      sku                 = string
      admin_enabled       = string
    }
  ))
}