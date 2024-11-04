output "server_host" {
  value = azurerm_postgresql_flexible_server.psql_server.fqdn
}


output "administrator_password" {
  value     = random_password.postgres_password.result
  sensitive = true
}

output "administrator_login" {
  value = var.administrator_login

}

output "database_name" {
  value = var.database_name

}

