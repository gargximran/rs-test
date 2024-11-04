module "naming_resource_01" {
  source  = "Azure/naming/azurerm"
  suffix  = [var.app_name, var.environment, var.location, "01"]
  version = "~> 0.3"
}

resource "azurerm_resource_group" "rg" {
  name     = module.naming_resource_01.resource_group.name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = module.naming_resource_01.virtual_network.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "snet" {
  name                 = module.naming_resource_01.subnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Web"]
}

resource "azurerm_public_ip" "pip" {
  name                = module.naming_resource_01.public_ip.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  zones               = ["1"]
  sku                 = "Standard"
}

module "postgresql_database_server" {
  source                 = "./modules/postgresql-flexible-server"
  server_name            = module.naming_resource_01.postgresql_server.name
  database_name          = var.database_name
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = var.administrator_login
  allow_start_ip_address = module.demo-app-service.outbountd_ip_addresses
  sku_name               = var.postgresql_sku_name
}

module "demo-app-service" {
  source              = "./modules/app-service"
  location            = azurerm_resource_group.rg.location
  rg_name             = azurerm_resource_group.rg.name
  service_plan_name   = module.naming_resource_01.app_service_plan.name
  app_service_name    = module.naming_resource_01.app_service.name
  whitelist_subnet_id = azurerm_subnet.snet.id
  tags                = var.tags
  image_name          = var.image_name
  app_env_variables = {
    DB_USER         = module.postgresql_database_server.administrator_login
    DB_HOST         = module.postgresql_database_server.server_host
    DB_NAME         = module.postgresql_database_server.database_name
    DB_PASSWORD     = module.postgresql_database_server.administrator_password
    DB_PORT         = "5431"
    WEBSITES_PORT = "3000"
  }
}


module "application_gateway" {
  source                     = "./modules/application-gateway"
  name                       = module.naming_resource_01.application_gateway.name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  backend_address_pool_fqdns = module.demo-app-service.fqdns
  public_ip_address_id       = azurerm_public_ip.pip.id
  subnet_id                  = azurerm_subnet.snet.id
  gateway_sku                = var.gateway_sku
  gateway_tier               = var.gateway_tier
  firewall_mode              = var.firewall_mode
  tags                       = var.tags
  rule_set_type              = var.rule_set_type
  rule_set_version           = var.rule_set_version
}
