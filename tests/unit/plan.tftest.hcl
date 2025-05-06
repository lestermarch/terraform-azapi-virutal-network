variables {
  address_space     = "10.99.0.0/24"
  location          = "uksouth"
  resource_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock"

  resource_tags = {
    CreatedBy   = "Terraform Test"
    Environment = "Test"
  }

  subnets = [
    {
      name = "SimpleSubnet"
      size = 26
    },
    {
      name                                     = "DelegatedSubnet"
      size                                     = 26
      delegation                               = "Microsoft.ContainerInstance/containerGroups"
      enable_private_endpoint_network_policies = true
      nat_gateway_id                           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/natGateways/ng-mock"
    },
    {
      name = "ServiceEndpointSubnet"
      size = 26
      service_endpoints = [
        "Microsoft.ContainerRegistry",
        "Microsoft.KeyVault",
        "Microsoft.Storage"
      ]
    }
  ]
}

run "plan" {
  command = plan

  # Virtual Network: Address Space (Variable Input)
  assert {
    condition     = azapi_resource.virtual_network.body.properties.addressSpace.addressPrefixes[0] == "10.99.0.0/24"
    error_message = "The virtual network address space should be \"10.99.0.0/24\"."
  }

  # Virtual Network: Location (Variable Input)
  assert {
    condition     = azapi_resource.virtual_network.location == "uksouth"
    error_message = "The virtual network location should be \"uksouth\"."
  }

  # Virtual Network: Resource Group ID (Variable Input)
  assert {
    condition     = azapi_resource.virtual_network.parent_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock"
    error_message = "The virtual network resource group ID should be \"/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock\"."
  }

  # Virtual Network: Resource Tags (Variable Input)
  assert {
    condition     = contains(keys(azapi_resource.virtual_network.tags), "CreatedBy")
    error_message = "The virtual network tags should include a \"CreatedBy\" key."
  }

  # Virtual Network: Subnets: SimpleSubnet Name (Variable Input)
  assert {
    condition     = azapi_resource.subnet["SimpleSubnet"].name == "SimpleSubnet"
    error_message = "The first subnet should be named \"SimpleSubnet\"."
  }

  # Virtual Network: Subnets: SimpleSubnet Address Space (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["SimpleSubnet"].body.properties.addressPrefix == "10.99.0.0/26"
    error_message = "The first subnet should have an address prefix of \"10.99.0.0/26\"."
  }

  # Virtual Network: Subnets: SimpleSubnet Default Outbound Access (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["SimpleSubnet"].body.properties.defaultOutboundAccess == false
    error_message = "The first subnet should have default outbound access set to \"false\"."
  }

  # Virtual Network: Subnets: SimpleSubnet Delegations (Internal Logic)
  assert {
    condition     = length(azapi_resource.subnet["SimpleSubnet"].body.properties.delegations) == 0
    error_message = "The first subnet should not have any delegations."
  }

  # Virtual Network: Subnets: SimpleSubnet Private Endpoint Network Policies (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["SimpleSubnet"].body.properties.privateEndpointNetworkPolicies == "Disabled"
    error_message = "The first subnet should have private endpoint network policies set to \"Disabled\"."
  }

  # Virtual Network: Subnets: SimpleSubnet Private Link Service Network Policies (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["SimpleSubnet"].body.properties.privateLinkServiceNetworkPolicies == "Enabled"
    error_message = "The first subnet should have private link service network policies set to \"Enabled\"."
  }

  # Virtual Network: Subnets: SimpleSubnet Service Endpoints (Internal Logic)
  assert {
    condition     = length(azapi_resource.subnet["SimpleSubnet"].body.properties.serviceEndpoints) == 0
    error_message = "The first subnet should not have any service endpoints."
  }

  # Virtual Network: Subnets: DelegatedSubnet Name (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["DelegatedSubnet"].name == "DelegatedSubnet"
    error_message = "The second subnet should be named \"DelegatedSubnet\"."
  }

  # Virtual Network: Subnets: DelegatedSubnet Address Space (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["DelegatedSubnet"].body.properties.addressPrefix == "10.99.0.64/26"
    error_message = "The second subnet should have an address prefix of \"10.99.0.64/26\"."
  }

  # Virtual Network: Subnets: DelegatedSubnet Default Outbound Access (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["DelegatedSubnet"].body.properties.defaultOutboundAccess == false
    error_message = "The second subnet should have default outbound access set to \"false\"."
  }

  # Virtual Network: Subnets: DelegatedSubnet Delegations (Internal Logic)
  assert {
    condition     = length(azapi_resource.subnet["DelegatedSubnet"].body.properties.delegations) == 1
    error_message = "The second subnet should have one delegation."
  }

  # Virtual Network: Subnets: DelegatedSubnet Delegation Name (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["DelegatedSubnet"].body.properties.delegations[0].name == "Microsoft.ContainerInstance-containerGroups"
    error_message = "The second subnet's delegation should be named \"Microsoft.ContainerInstance-containerGroups\"."
  }

  # Virtual Network: Subnets: DelegatedSubnet Delegation Service Name (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["DelegatedSubnet"].body.properties.delegations[0].properties.serviceName == "Microsoft.ContainerInstance/containerGroups"
    error_message = "The second subnet's delegation service name should be \"Microsoft.ContainerInstance/containerGroups\"."
  }

  # Virtual Network: Subnets: DelegatedSubnet NAT Gateway ID (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["DelegatedSubnet"].body.properties.natGateway.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/natGateways/ng-mock"
    error_message = "The second subnet should have a NAT gateway ID of \"/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/natGateways/ng-mock\"."
  }

  # Virtual Network: Subnets: DelegatedSubnet Private Endpoint Network Policies (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["DelegatedSubnet"].body.properties.privateEndpointNetworkPolicies == "Enabled"
    error_message = "The second subnet should have private endpoint network policies set to \"Enabled\"."
  }

  # Virtual Network: Subnets: DelegatedSubnet Private Link Service Network Policies (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["DelegatedSubnet"].body.properties.privateLinkServiceNetworkPolicies == "Enabled"
    error_message = "The second subnet should have private link service network policies set to \"Enabled\"."
  }

  # Virtual Network: Subnets: DelegatedSubnet Service Endpoints (Internal Logic)
  assert {
    condition     = length(azapi_resource.subnet["DelegatedSubnet"].body.properties.serviceEndpoints) == 0
    error_message = "The second subnet should not have any service endpoints."
  }

  # Virtual Network: Subnets: ServiceEndpointSubnet Name (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["ServiceEndpointSubnet"].name == "ServiceEndpointSubnet"
    error_message = "The third subnet should be named \"ServiceEndpointSubnet\"."
  }

  # Virtual Network: Subnets: ServiceEndpointSubnet Address Space (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.addressPrefix == "10.99.0.128/26"
    error_message = "The third subnet should have an address prefix of \"10.99.0.128/26\"."
  }

  # Virtual Network: Subnets: ServiceEndpointSubnet Default Outbound Access (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.defaultOutboundAccess == false
    error_message = "The third subnet should have default outbound access set to \"false\"."
  }

  # Virtual Network: Subnets: ServiceEndpointSubnet Delegations (Internal Logic)
  assert {
    condition     = length(azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.delegations) == 0
    error_message = "The third subnet should not have any delegations."
  }

  # Virtual Network: Subnets: ServiceEndpointSubnet Private Endpoint Network Policies (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.privateEndpointNetworkPolicies == "Disabled"
    error_message = "The third subnet should have private endpoint network policies set to \"Disabled\"."
  }

  # Virtual Network: Subnets: ServiceEndpointSubnet Private Link Service Network Policies (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.privateLinkServiceNetworkPolicies == "Enabled"
    error_message = "The third subnet should have private link service network policies set to \"Enabled\"."
  }

  # Virtual Network: Subnets: ServiceEndpointSubnet Service Endpoints (Internal Logic)
  assert {
    condition     = length(azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.serviceEndpoints) == 3
    error_message = "The third subnet should have three service endpoints."
  }

  # Virtual Network: Subnets: ServiceEndpointSubnet Service Endpoint Names (Internal Logic)
  assert {
    condition     = azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.serviceEndpoints[0].service == "Microsoft.ContainerRegistry"
    error_message = "The third subnet's first service endpoint should be \"Microsoft.ContainerRegistry\"."
  }

  assert {
    condition     = azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.serviceEndpoints[1].service == "Microsoft.KeyVault"
    error_message = "The third subnet's second service endpoint should be \"Microsoft.KeyVault\"."
  }

  assert {
    condition     = azapi_resource.subnet["ServiceEndpointSubnet"].body.properties.serviceEndpoints[2].service == "Microsoft.Storage"
    error_message = "The third subnet's third service endpoint should be \"Microsoft.Storage\"."
  }
}
