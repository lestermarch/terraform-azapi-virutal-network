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
  resource_group_name = "rg-${local.resource_suffix}"
  resource_suffix     = "${random_pet.resource_suffix.id}-${random_integer.resource_suffix.id}"
}

# Resource group
resource "azapi_resource" "resource_group" {
  type = "Microsoft.Resources/resourceGroups@2024-07-01"

  name     = local.resource_group_name
  location = var.location
}
