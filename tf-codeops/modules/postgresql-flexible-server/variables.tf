variable "server_name" {
  description = "The name of the PostgreSQL server."
  type        = string

}

variable "database_name" {
  description = "The name of the PostgreSQL database."
  type        = string

}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string

}

variable "location" {
  description = "The location/region where the resource group will be created."
  type        = string

}

variable "administrator_login" {
  description = "The administrator login for the PostgreSQL server."
  type        = string

}

variable "allow_start_ip_address" {
  description = "The starting IP address to allow access to the PostgreSQL server."
  type        = list(string)
}

variable "sku_name" {
  description = "The SKU name of the PostgreSQL server."
  type        = string
}

