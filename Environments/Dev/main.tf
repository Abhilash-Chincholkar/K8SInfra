data "azurerm_client_config" "current" {}

module "resource_group" {
  source = "../../Modules/Azurerm_Resource_Group"
  rgs    = var.rgs
}

# Data source for ACR is not needed as we have the ACR module

module "storage_account" {
  depends_on   = [module.resource_group]
  source       = "../../Modules/Azurerm_Storage_Account"
  stg_accounts = var.stg_accounts
}

module "storage_container" {
  depends_on = [module.storage_account]
  source     = "../../Modules/Azurerm_Storage_Container"
  containers = {
    container1 = {
      name                  = "terraform"
      storage_account_id    = module.storage_account.stg_account_id["stg1"]
      container_access_type = "private"
    }
    #   container2 = {
    #     name                  = "terraform-state"
    #     storage_account_id    = module.storage_account.stg_account_id["stg2"]
    #     container_access_type = "private"
    #   }
  }
}



module "acr" {
  source     = "../../Modules/Azurerm_Container_Registry"
  depends_on = [module.resource_group]
  acr        = var.acr
}

# Create AKS without AGW integration first
module "aks" {
  source              = "../../Modules/Azurerm_Kubernetes_Cluster"
  depends_on          = [module.resource_group, module.acr]
  kubernetes_clusters = var.kubernetes_clusters
  acr_id             = module.acr.acr_id["acr1"]
  # We'll add AGW integration later
  application_gateway_id = ""
}

module "sql_server" {
  source      = "../../Modules/Azurerm_SQL_Server"
  depends_on  = [module.resource_group]
  sql_servers = var.sql_servers
}

module "sql_database" {
  source     = "../../Modules/Azurerm_SQL_Database"
  depends_on = [module.sql_server]
  sql_dbs    = var.sql_dbs
  server_id  = module.sql_server.sql_server_id["sql_server1"]
}

module "public_ip" {
  source     = "../../Modules/Azurerm_Public_IP"
  depends_on = [module.resource_group]
  pips       = var.pips
}

# Key Vault module is commented out as it's not properly configured yet
module "key_vault" {
  source     = "../../Modules/Azurerm_Keyvault"
  depends_on = [module.resource_group]
  keyvaults  = var.keyvaults
}

module "virtual_networks" {
  source = "../../Modules/Azurerm_Virtual_Network"
  depends_on = [ module.resource_group ]
  virtual_network = var.virtual_network
}

module "agw" {
  source = "../../Modules/Azurerm_Application_Gateway"
  depends_on = [module.virtual_networks, module.public_ip]
  agw = var.agw
}

resource "azurerm_role_assignment" "agic_contributor" {
  principal_id         = module.aks.kubernetes_principal_id["cluster1"]
  role_definition_name = "Contributor"
  scope                = module.agw.application_gateway_id["ag1"]
}

resource "azurerm_role_assignment" "agic_rg_contributor" {
  principal_id         = module.aks.kubernetes_principal_id["cluster1"]
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.agw["ag1"].resource_group_name}"
}

resource "azurerm_role_assignment" "acr_pull" {
  for_each = module.aks.kubelet_identity_ids    

  principal_id                     = each.value
  role_definition_name             = "AcrPull"
  scope                            = module.acr.acr_id["acr1"]
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster_extension" "agic" {
  name           = "agic"
  cluster_id     = module.aks.kubernetes_cluster_id["cluster1"]
  extension_type = "microsoft.azureappgw.ingressapplicationgateway"

  configuration_settings = {
    "appgw.applicationGatewayId" = module.agw.application_gateway_id["ag1"]
    "appgw.subnetId"            = module.virtual_networks.subnet_ids["Vnet1"][var.agw["ag1"].subnet_name]
  }

  depends_on = [
    module.aks,
    module.agw
  ]
}