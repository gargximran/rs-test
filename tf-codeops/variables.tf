# Application Details
variable "app_name" {
  description = "The name of the app service."
  type        = string
}

variable "location" {
  description = "The location/region where the resource group will be created."
  type        = string
}

variable "environment" {
  description = "The environment in which the resources will be created."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

# App Service Configuration
variable "image_name" {
  description = "The name of the Docker image to deploy."
  type        = string
}

# Gateway Configuration
variable "gateway_sku" {
  description = "The SKU of the application gateway."
  type        = string
}

variable "gateway_tier" {
  description = "The tier of the application gateway."
  type        = string
}

variable "firewall_mode" {
  description = "The mode of the WAF (e.g., Prevention or Detection)."
  type        = string
}

variable "rule_set_type" {
  description = "The type of rule set to use with the WAF (e.g., OWASP)."
  type        = string
}

variable "rule_set_version" {
  description = "The version of the rule set to use with the WAF."
  type        = string
}

# PostgreSQL Configuration
variable "administrator_login" {
  description = "The administrator login for the PostgreSQL server."
  type        = string
}

variable "database_name" {
  description = "The name of the PostgreSQL database."
  type        = string
}

variable "postgresql_sku_name" {
  description = "The SKU name for the PostgreSQL server instance."
  type        = string
}
