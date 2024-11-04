
locals {
  backend_setting_name           = "backend-setting-${var.name}"
  backend_address_pool_name      = "backend-pool-${var.name}"
  frontend_setting_name          = "frontend-setting-${var.name}"
  http_listener_name             = "http-listener-${var.name}"
  request_routing_rule_name      = "request-routing-rule-${var.name}"
  frontend_ip_configuration_name = "frontend-ip-configuration-${var.name}"
  frontend_port_name             = "frontend-port-${var.name}"
  app_gateway_ip_config_name     = "app-gateway-ip-config-${var.name}"
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_http2 = true

  tags = var.tags
  zones = [
    "1"
  ]

  autoscale_configuration {
    max_capacity = 2
    min_capacity = 1
  }

  backend_address_pool {
    fqdns = [
      var.backend_address_pool_fqdns
    ]
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    cookie_based_affinity = "Disabled"

    name                                = local.backend_setting_name
    pick_host_name_from_backend_address = true
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 20
    probe_name                          = "gateway-probe"
  }

  probe {
    interval                                  = 30
    path                                      = "/"
    protocol                                  = "Https"
    timeout                                   = 30
    pick_host_name_from_backend_http_settings = true
    port                                      = 443
    name                                      = "gateway-probe"
    unhealthy_threshold                       = 3
    match {
      status_code = [
        "200-399"
      ]
      body = ""
    }    
  }



  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.public_ip_address_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  gateway_ip_configuration {
    name      = local.app_gateway_ip_config_name
    subnet_id = var.subnet_id
  }

  http_listener {
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    name                           = local.http_listener_name
    protocol                       = "Http"

  }



  request_routing_rule {
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_setting_name
    http_listener_name         = local.http_listener_name
    name                       = local.request_routing_rule_name
    priority                   = 1000
    rule_type                  = "Basic"
  }

  sku {
    name = var.gateway_sku
    tier = var.gateway_tier
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = var.firewall_mode
    rule_set_type    = var.rule_set_type
    rule_set_version = var.rule_set_version
  }
}
