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
