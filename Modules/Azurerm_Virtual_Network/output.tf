output "stg_account_id" {
  value = { for key,stg in azurerm_storage_account.storage_account: key => stg.id }
  description = "stg account id"
}

output "stg_account_name" {
  value       = { for key, stg in azurerm_storage_account.storage_account : key => stg.name }
  description = "Map of storage account names"
}