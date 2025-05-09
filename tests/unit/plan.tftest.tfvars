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
    network_security_group_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/networkSecurityGroups/nsg-mock"
  },
  {
    name = "ServiceEndpointSubnet"
    size = 26
    service_endpoints = [
      "Microsoft.ContainerRegistry",
      "Microsoft.KeyVault",
      "Microsoft.Storage"
    ]
  },
  {
    name           = "RouteAllSubnet"
    size           = 26
    route_table_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-mock/providers/Microsoft.Network/routeTables/rt-mock"
  }
]
