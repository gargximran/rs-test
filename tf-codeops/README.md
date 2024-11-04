# Terraform Azure Infrastructure Deployment

## Overview
This Terraform configuration provisions a structured infrastructure on Azure, deploying a network, application services, database, and security components. The setup is modular, scalable, and designed for security compliance, making it suitable for multi-environment deployments.

## Prerequisites
- **Terraform v1.9.8** or later.
- **Azure CLI** for authenticating with Azure and managing resources.
- An **Azure Subscription** with permissions to create resources.

## Application Details
Here are the primary application details, which define the app, environment, and tags for easy identification and management:

```hcl
app_name    = "rs"            # Name of the app service
location    = "eastus2"       # Azure region for the resource group
environment = "dev"           # Deployment environment (e.g., dev, prod)
tags = {
  owner       = "devops"
  created_by  = "terraform"
}
```

## Terraform Configuration

### Provider
This setup uses the **AzureRM provider** version `4.8.0` from HashiCorp to manage Azure resources. Put the subscription id in provider block:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.8.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "<subscription-id>"
  features {}
}
```

### Optional Remote Backend for State Storage
An **Azure Storage** backend configuration is provided (currently commented) to manage Terraform state remotely, useful in team environments for secure and consistent state management. To enable the backend, uncomment the backend block and provide the required values:

```hcl
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "<resource-group-name>"
#     storage_account_name = "<storage-account-name>"
#     container_name       = "<container-name>"
#     key                  = "<terraform.tfstate>"
#   }
# }
```

**Fill in:**
- `resource_group_name`: Resource group name for the storage account.
- `storage_account_name`: Azure Storage account name.
- `container_name`: Blob container name for storing the state file.
- `key`: Path or name of the state file within the container (e.g., `terraform.tfstate`).

### Modules and Resources

The configuration is organized into modules to support scalability, modularity, and reusability:

- **Naming Module**: Generates standardized names for resources using a combination of variables such as application name, environment, and location.
- **Resource Group**: A centralized Azure Resource Group that serves as a container for all deployed resources.
- **Virtual Network and Subnet**: Defines a segmented network environment with an address space of `10.0.0.0/16` and subnet prefix of `10.0.1.0/24`.
- **Public IP**: A Standard SKU public IP is allocated for the Application Gateway to provide static external access.
- **PostgreSQL Flexible Server**: Deploys a PostgreSQL database with specified credentials and access configuration, allowing traffic only from the App Service’s outbound IPs.
- **App Service**: Deploys a Docker image, `gargximran/waf-test:v1`, from the user’s public Docker Hub registry. Since the image is public, no Docker credentials are needed.
- **Application Gateway**: Configured with Web Application Firewall (WAF) in prevention mode, securing traffic with OWASP rule set version `3.2` and directing requests to the App Service’s backend FQDN.

### Outputs
After deployment, the configuration outputs the **Application Gateway's public IP address**, allowing secure external access to the application.

```hcl
output "gateway_ip" {
  value = azurerm_public_ip.pip.ip_address
}
```

### App Service Configuration
For the application service, the configuration deploys a public Docker image with essential settings:

```hcl
image_name = "gargximran/waf-test:v1"  # Docker image to deploy
```

### Gateway Configuration
The application gateway is set up as a Web Application Firewall with customized settings:

```hcl
gateway_sku       = "WAF_v2"       # SKU for the application gateway
gateway_tier      = "WAF_v2"       # Gateway tier for application security
firewall_mode     = "Prevention"   # WAF mode (Prevention or Detection)
rule_set_type     = "OWASP"        # WAF rule set type (e.g., OWASP)
rule_set_version  = "3.2"          # Version of the rule set for WAF
```

### PostgreSQL Configuration
PostgreSQL is configured with the following parameters:

```hcl
administrator_login = "psqladmin"  # Admin login for PostgreSQL server
database_name       = "mydatabase" # Database name within PostgreSQL
postgresql_sku_name = "B_Standard_B1ms" # SKU for PostgreSQL server instance
```

## Usage

1. **Clone the Repository**:
   ```bash
   git clone git@github.com:gargximran/rs-test.git
   cd rs-test/tf-codeops
   ```

2. **Set Up Variables**:
   Populate the required variables in a `.tfvars` file, as defined in `variables.tf`.

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Validate and Apply Configuration**:
   Validate the configuration for errors and apply it to create the resources:

   ```bash
   terraform plan
   terraform apply -var-file="your-values.tfvars"
   ```

5. **Review Outputs**:
   After deployment, check the output `gateway_ip` for the Application Gateway's IP address, which you can use to access the application.

6. **Enable Remote Backend (Optional)**:
   If using remote state, uncomment the backend configuration in `backend.tf`, add Azure Storage details, and re-run `terraform init` to initialize the backend.

## Cleanup
To destroy all resources created by this configuration, run:

```bash
terraform destroy -var-file="your-values.tfvars"
```

## Notes
- **Provider Version Compatibility**: The setup uses AzureRM version `4.8.0` with Terraform v1.9.8.
- **Public Image Registry**: The App Service module pulls a Docker image from a public registry on Docker Hub, so no Docker credentials are required.
- **Remote State Management**: Enabling the Azure Storage backend is recommended for teams to centralize state management.
- **Security and Best Practices**: The Application Gateway is configured in WAF prevention mode with OWASP rules, providing robust protection against web threats.

