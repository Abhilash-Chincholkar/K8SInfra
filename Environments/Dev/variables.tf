variable "rgs" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}

variable "stg_accounts" {
  type = map(object(
    {
      name                     = string
      resource_group_name      = string
      location                 = string
      account_tier             = string
      account_replication_type = string
      tags                     = optional(map(string))

    }
  ))
}

variable "containers" {
  type = map(object({
    name                  = string
    storage_account_id    = string
    container_access_type = string
  }))
}

variable "kubernetes_clusters" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    dns_prefix          = string
    node_pools = list(object({
      name       = string
      node_count = number
      vm_size    = string
    }))
    identity = list(object({
      type = string
    }))
    tags = map(string)
  }))
  description = "Map of Kubernetes clusters to create"
}

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

variable "sql_servers" {
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    version                      = string
    administrator_login          = string
    administrator_login_password = string
    minimum_tls_version          = number
  }))
}

variable "sql_dbs" {
  type = map(object(
    {
      name         = string
      server_id    = string
      collation    = string
      license_type = string
      max_size_gb  = string
      sku_name     = string
      enclave_type = string
    }
  ))
}


variable "pips" {
  type = map(object({
    public_ip_name      = string
    resource_group_name = string
    location            = string
    allocation_method   = string
    tags                = optional(map(string))
  }))

}

variable "keyvaults" {
  type = map(object({
    kv_name             = string
    location            = string
    resource_group_name = string

  }))
}

variable "virtual_network" {
  type = map(object({
    vnet_name           = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    subnets = map(object({
      subnet_name      = string
      address_prefixes = list(string)
    }))
    tags = map(string)
  }))
}

variable "agw" {
  type = map(object({
    agw_name             = string
    resource_group_name  = string
    location             = string
    subnet_name          = string
    virtual_network_name = string
    public_ip_name       = string
    sku_name             = string
    tier                 = string
    capacity             = number
    gateway_ip_configuration = object({
      name = string
    })
    frontend_ip_configurations = list(object({
      name = string

    }))
    frontend_ports = list(object({
      name = string
      port = number
    }))
    backend_address_pools = list(object({
      name = string
    }))
    backend_http_settings = list(object({
      name                  = string
      port                  = number
      protocol              = string
      cookie_based_affinity = string
      request_timeout       = number
    }))

    # http listeners
    http_listeners = list(object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
    }))

    # routing rules
    request_routing_rules = list(object({
      name                       = string
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    }))
  }))
}


