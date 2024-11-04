variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)

}

variable "name" {
  description = "The name of the app service."
  type        = string

}

variable "location" {
  description = "The location/region where the resource group will be created."
  type        = string

}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string

}

variable "backend_address_pool_fqdns" {
  description = "The FQDNs of the backend address pool."
  type        = string

}


variable "public_ip_address_id" {
  description = "The ID of the public IP address."
  type        = string

}


variable "subnet_id" {
  description = "The ID of the subnet."
  type        = string

}

variable "gateway_sku" {
  description = "The SKU of the application gateway."
  type        = string

}

variable "gateway_tier" {
  description = "The tier of the application gateway."
  type        = string

}


variable "firewall_mode" {
  description = "The mode of the WAF."
  type        = string

}


variable "rule_set_type" {
  description = "The type of rule set to use with the WAF."
  type        = string

}

variable "rule_set_version" {
  description = "The version of the rule set to use with the WAF."
  type        = string

}
