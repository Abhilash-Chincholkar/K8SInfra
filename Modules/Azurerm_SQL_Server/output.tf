output "sql_server_id" {
  value = { for key, server in azurerm_mssql_server.sql_server : key => server.id }
  description = "Map of SQL Server IDs"
}