locals {
  # Determine the name of the virtual network
  name = coalesce(var.name, "vnet-${local.resource_suffix}")

  # Generate a resource suffix for resources where a resource name is not provided
  resource_suffix = "${random_pet.resource_suffix.id}-${random_integer.resource_suffix.id}"

  # Transform each subnet definition into a format suitable for the hashicorp/subnets/cidr module
  subnets = [
    for subnet in var.subnets : {
      name     = subnet.name
      new_bits = subnet.size - split("/", var.address_space)[1]
    }
  ]

  # Create a data structure for subnet delegation configuration as required by the Azure API
  subnet_delegation = {
    for subnet in var.subnets :
    subnet.name => [
      {
        name = replace(subnet.delegation, "/", "-")
        properties = {
          serviceName = subnet.delegation
        }
      }
    ] if subnet.delegation != null
  }

  # Create a data structure for subnet NAT gateway configuration as required by the Azure API
  subnet_nat_gateway = {
    for subnet in var.subnets :
    subnet.name => {
      id = subnet.nat_gateway_id
    } if subnet.nat_gateway_id != null
  }

  # Convert the subnet network policy boolean parameter values to valid string values for the Azure API
  subnet_network_policies = {
    for subnet in var.subnets :
    subnet.name => {
      private_endpoint     = subnet.enable_private_endpoint_network_policies ? "Enabled" : "Disabled"
      private_link_service = subnet.enable_private_link_service_network_policies ? "Enabled" : "Disabled"
    }
  }

  # Create a data structure for service endpoints configuration as required by the Azure API
  subnet_service_endpoints = {
    for subnet in var.subnets :
    subnet.name => [
      for endpoint in subnet.service_endpoints : {
        service = endpoint
      }
    ]
  }
}
