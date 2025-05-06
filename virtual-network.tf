# Generate subnet configuration based on the provided address space and subnet definitions
module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.address_space
  networks        = local.subnets
}

# Create the virtual network
resource "azapi_resource" "virtual_network" {
  type = "Microsoft.Network/virtualNetworks@2024-05-01"

  name      = local.name
  location  = var.location
  parent_id = var.resource_group_id
  tags      = var.resource_tags

  body = {
    properties = {
      addressSpace = {
        addressPrefixes = [var.address_space]
      }
    }
  }
}

# Dynamically create subnets based on the generated configuration
resource "azapi_resource" "subnet" {
  for_each = module.subnets.network_cidr_blocks

  type = "Microsoft.Network/virtualNetworks/subnets@2024-05-01"

  name      = each.key
  locks     = [azapi_resource.virtual_network.id]
  parent_id = azapi_resource.virtual_network.id

  body = {
    properties = {
      addressPrefix                     = each.value
      defaultOutboundAccess             = false
      delegations                       = try(local.subnet_delegation[each.key], [])
      natGateway                        = try(local.subnet_nat_gateway[each.key], null)
      privateEndpointNetworkPolicies    = local.subnet_network_policies[each.key].private_endpoint
      privateLinkServiceNetworkPolicies = local.subnet_network_policies[each.key].private_link_service
      serviceEndpoints                  = local.subnet_service_endpoints[each.key]
    }
  }
}
