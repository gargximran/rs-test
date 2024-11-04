resource "azurerm_service_plan" "service_plan" {
  os_type             = "Linux"
  sku_name            = var.sku_size
  location            = var.location
  name                = var.service_plan_name
  resource_group_name = var.rg_name
  tags                = var.tags

}


resource "azurerm_linux_web_app" "app_service" {
  service_plan_id     = azurerm_service_plan.service_plan.id
  location            = var.location
  name                = var.app_service_name
  resource_group_name = var.rg_name
  tags                = var.tags


  app_settings = var.app_env_variables

  # {
  #   "WEBSITES_PORT" = "3000"
  #   "DB_USER"       = var.app_env_variables.DB_USER
  #   "DB_HOST"       = var.app_env_variables.DB_HOST
  #   "DB_NAME"       = var.app_env_variables.DB_NAME
  #   "DB_PASSWORD"   = var.app_env_variables.DB_PASSWORD
  #   "DB_PORT"       = var.app_env_variables.DB_PORT
  # }

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = var.image_name
      docker_registry_url = "https://index.docker.io"
    }

    ip_restriction {
      action                    = "Allow"
      name                      = "allow_from_gateway_subnet"
      priority                  = 100
      virtual_network_subnet_id = var.whitelist_subnet_id
      headers                   = []
    }

    ip_restriction_default_action = "Deny"
  }
}
