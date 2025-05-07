terraform {
  required_version = "~> 1.0"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Resource name entropy
resource "random_integer" "resource_suffix" {
  max = 999
  min = 100
}

resource "random_pet" "resource_suffix" {}

# Local variables
locals {
  nat_gateway_idle_timeout_minutes = 4
  nat_gateway_name                 = "ng-${local.resource_suffix}"
  nat_gateway_public_ip_name       = "${local.nat_gateway_name}-pip"
  network_security_group_name      = "nsg-${local.resource_suffix}"
  resource_group_name              = "rg-${local.resource_suffix}"
  resource_suffix                  = "${random_pet.resource_suffix.id}-${random_integer.resource_suffix.id}"
}

# Resource group
resource "azapi_resource" "resource_group" {
  type = "Microsoft.Resources/resourceGroups@2024-07-01"

  name     = local.resource_group_name
  location = var.location
}

# NAT Gateway
resource "azapi_resource" "nat_gateway_public_ip" {
  type = "Microsoft.Network/publicIPAddresses@2024-05-01"

  name      = local.nat_gateway_public_ip_name
  location  = var.location
  parent_id = azapi_resource.resource_group.id

  body = {
    properties = {
      idleTimeoutInMinutes     = local.nat_gateway_idle_timeout_minutes
      publicIPAddressVersion   = "IPv4"
      publicIPAllocationMethod = "Static"
    }

    sku = {
      name = "Standard"
      tier = "Regional"
    }
  }
}

resource "azapi_resource" "nat_gateway" {
  type = "Microsoft.Network/natGateways@2024-05-01"

  name      = local.nat_gateway_name
  location  = var.location
  parent_id = azapi_resource.resource_group.id

  body = {
    properties = {
      idleTimeoutInMinutes = local.nat_gateway_idle_timeout_minutes

      publicIpAddresses = [
        {
          id = azapi_resource.nat_gateway_public_ip.id
        }
      ]
    }

    sku = {
      name = "Standard"
    }
  }
}

# Network Security Group
resource "azapi_resource" "network_security_group" {
  type = "Microsoft.Network/networkSecurityGroups@2024-05-01"

  name      = local.network_security_group_name
  location  = var.location
  parent_id = azapi_resource.resource_group.id

  body = {
    properties = {
      securityRules = [
        {
          name = "Allow-SSH"

          properties = {
            access                   = "Allow"
            direction                = "Inbound"
            priority                 = 100
            protocol                 = "Tcp"
            sourceAddressPrefix      = "*"
            sourcePortRange          = "*"
            destinationAddressPrefix = "*"
            destinationPortRange     = "22"
          }
        }
      ]
    }
  }
}
