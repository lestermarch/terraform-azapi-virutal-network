# Azure Virtual Network (AzAPI)

A Terraform module for deploying an Azure Virtual Network and subnets using the AzAPI provider.

## Design Decisions

This module aims to simplify provisioning of an Azure Virtual Network and subnets and is opinionated in its implementation. Below are some notable points to consider:

1. Subnet default outbound access is disabled by default. Additional configuraiton is required for subnets where data exfiltration (direct egress traffic to the Internet) is desirable. The `subnets` input supports associating an existing NAT Gateway or Route Table to individual subnets to enable this functionality if required. See [default outbound access in Azure](https://learn.microsoft.com/en-us/azure/virtual-network/ip-services/default-outbound-access) for more information.

2. Subnets are provisioned dynamically based on the address space of the virtual network, specified subnet size, and order provided as part of the `subnets` input. In this way, only the size of a subnet needs to be provided, not the specific address range. The cumulative size of all subnets must fit within the total address space. Those unfamiliar with subnetting might want to refer to a [visual subnet calculator](https://www.davidc.net/sites/default/subnets/subnets.html).

3. While the Azure API for subnets supports in-line definitions for Network Security Groups and Route Tables, this module requires that those resources are provisioned outside of the module and passed into the subnet definition via their resource ID.

4. Some subnet attributes, such as IP allocations, IPAM pool prefix allocations, and service endpoint policies are not implemented due to their uncommon usage.

## Usage

See [usage examples](./docs/usage-examples.md) or [inputs](#inputs) for example module configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_subnets"></a> [subnets](#module\_subnets) | hashicorp/subnets/cidr | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.subnet](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.virtual_network](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [random_integer.resource_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_pet.resource_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The CIDR range to assign as the root address space for the virtual network. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The region into which resources will be deployed. | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the resource group into which resources will be deployed. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of objects defining the subnets to create, in the format:<pre>[<br/>  {<br/>    name = "SimpleSubnet"<br/>    size = 26<br/>  },<br/>  {<br/>    name       = "DelegatedSubnet"<br/>    size       = 26<br/>    delegation = "Microsoft.ContainerInstance/containerGroups"<br/>  },<br/>  {<br/>    name = "ServiceEndpointSubnet"<br/>    size = 26<br/>    service_endpoints = [<br/>      "Microsoft.ContainerRegistry",<br/>      "Microsoft.KeyVault",<br/>      "Microsoft.Storage"<br/>    ]<br/>  }<br/>]</pre> | <pre>list(object({<br/>    name                                         = string<br/>    size                                         = number<br/>    delegation                                   = optional(string)<br/>    enable_private_endpoint_network_policies     = optional(bool, false)<br/>    enable_private_link_service_network_policies = optional(bool, true)<br/>    nat_gateway_id                               = optional(string)<br/>    network_security_group_id                    = optional(string)<br/>    route_table_id                               = optional(string)<br/>    service_endpoints                            = optional(list(string), [])<br/>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the virtual network. | `string` | `null` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | A map of key-value pairs to use as resource tags. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_address_space"></a> [subnet\_address\_space](#output\_subnet\_address\_space) | A map of subnet names to their respective CIDR range, in the format:<pre>{<br/>  "SimpleSubnet"          = "10.99.0.0/26",<br/>  "DelegatedSubnet"       = "10.99.64.0/26",<br/>  "ServiceEndpointSubnet" = "10.99.128.0/26"<br/>}</pre> |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | A map of subnet names to their respective IDs, in the format:<pre>{<br/>  "SimpleSubnet"          = "/subscriptions/.../Microsoft.Network/virtualNetworks/vnet-example/subnets/SimpleSubnet",<br/>  "DelegatedSubnet"       = "/subscriptions/.../Microsoft.Network/virtualNetworks/vnet-example/subnets/DelegatedSubnet",<br/>  "ServiceEndpointSubnet" = "/subscriptions/.../Microsoft.Network/virtualNetworks/vnet-example/subnets/ServiceEndpointSubnet"<br/>}</pre> |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the virtual network. |
<!-- END_TF_DOCS -->
