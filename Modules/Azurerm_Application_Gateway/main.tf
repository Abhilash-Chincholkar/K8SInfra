resource "azurerm_application_gateway" "agw" {
  for_each = var.agw
  name                = each.value.agw_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = each.value.appgw_subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontendPIP"
    public_ip_address_id = data.
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  backend_address_pool {
    name = "defaultpool"
  }

  backend_http_settings {
    name                  = "defaultSetting"
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 30
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontendPIP"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "defaultpool"
    backend_http_settings_name = "defaultSetting"
  }
}