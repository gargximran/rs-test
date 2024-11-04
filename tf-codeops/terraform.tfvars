# Application Details
app_name    = "rs"      # Name of the application
location    = "eastus2" # Azure region for the resource group
environment = "dev"     # Deployment environment (e.g., dev, prod)
tags = {                # Resource tags for identification and management
  owner      = "devops"
  created_by = "terraform"
}

# App Service Configuration
image_name = "gargximran/waf-test:v1" # Docker image to deploy

# Gateway Configuration
gateway_sku      = "WAF_v2"     # SKU for the application gateway
gateway_tier     = "WAF_v2"     # Gateway tier for application security
firewall_mode    = "Prevention" # WAF mode (Prevention or Detection)
rule_set_type    = "OWASP"      # WAF rule set type (e.g., OWASP)
rule_set_version = "3.2"        # Version of the rule set for WAF

# PostgreSQL Configuration
administrator_login = "psqladmin"       # Admin login for PostgreSQL server
database_name       = "mydatabase"      # Database name within PostgreSQL
postgresql_sku_name = "B_Standard_B1ms" # SKU for PostgreSQL server instance
