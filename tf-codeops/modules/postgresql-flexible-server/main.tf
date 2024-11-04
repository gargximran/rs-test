resource "random_password" "postgres_password" {
  length           = 16
  special          = true
  override_special = "#%&"
}


resource "azurerm_postgresql_flexible_server" "psql_server" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.administrator_login
  administrator_password = random_password.postgres_password.result
  backup_retention_days  = 7
  version                = "16"
  sku_name               = var.sku_name
  lifecycle {
    ignore_changes = [zone]
  }

}

resource "azurerm_postgresql_flexible_server_database" "database" {
  depends_on = [azurerm_postgresql_flexible_server.psql_server]
  name       = var.database_name
  server_id  = azurerm_postgresql_flexible_server.psql_server.id
  charset    = "utf8"
}


resource "azurerm_postgresql_flexible_server_firewall_rule" "rule" {
  for_each         = toset(var.allow_start_ip_address)
  name             = "allow_access-${replace(each.key, ".", "-")}"
  server_id        = azurerm_postgresql_flexible_server.psql_server.id
  start_ip_address = each.value
  end_ip_address   = each.value

}