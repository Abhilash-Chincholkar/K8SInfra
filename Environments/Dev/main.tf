module "resource_group" {
  source = "../../Modules/Azurerm_Resource_Group"
  rgs    = var.rgs
}

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

module "aks" {
  source              = "../../Modules/Azurerm_Kubernetes_Cluster"
  depends_on          = [module.resource_group, module.acr]
  kubernetes_clusters = var.kubernetes_clusters
  acr_id              = module.acr.acr_id["acr1"]
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