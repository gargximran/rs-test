output "fqdns" {
  value = azurerm_linux_web_app.app_service.default_hostname
}

output "outbountd_ip_addresses" {
  value = azurerm_linux_web_app.app_service.possible_outbound_ip_address_list
}