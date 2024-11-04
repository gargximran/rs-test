variable "location" {
  description = "The location/region where the resource group will be created."
  type        = string
}


variable "sku_tier" {
  description = "The tier of the app service plan."
  type        = string
  default     = "Basic"
}

variable "sku_size" {
  description = "The size of the app service plan."
  type        = string
  default     = "B1"
}
variable "rg_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string

}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "service_plan_name" {
  description = "The name of the app service plan."
  type        = string
}

variable "app_service_name" {
  description = "The name of the app service."
  type        = string
}

variable "whitelist_subnet_id" {
  description = "The ID of the subnet to whitelist."
  type        = string
}

variable "image_name" {
  description = "The name of the image to use for the app service."
  type        = string
  default     = "mcr.microsoft.com/appsvc/staticsite:latest"
}

variable "app_env_variables" {
  description = "A map of environment variables to set for the app service."
  type = map(string)
}