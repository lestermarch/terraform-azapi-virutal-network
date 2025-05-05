output "subnet_address_space" {
  description = <<-EOT
  A map of subnet names to their respective CIDR range, in the format:
  ```
  {
    "SimpleSubnet"          = "10.99.0.0/26",
    "DelegatedSubnet"       = "10.99.64.0/26",
    "ServiceEndpointSubnet" = "10.99.128.0/26"
  }
  ```
  EOT
  value = {
    for subnet in azapi_resource.subnet :
    subnet.name => subnet.body.properties.addressPrefix
  }
}

output "subnet_id" {
  description = <<-EOT
  A map of subnet names to their respective IDs, in the format:
  ```
  {
    "SimpleSubnet"          = "/subscriptions/.../Microsoft.Network/virtualNetworks/vnet-example/subnets/SimpleSubnet",
    "DelegatedSubnet"       = "/subscriptions/.../Microsoft.Network/virtualNetworks/vnet-example/subnets/DelegatedSubnet",
    "ServiceEndpointSubnet" = "/subscriptions/.../Microsoft.Network/virtualNetworks/vnet-example/subnets/ServiceEndpointSubnet"
  }
  ```
  EOT
  value = {
    for subnet in azapi_resource.subnet :
    subnet.name => subnet.id
  }
}

output "virtual_network_id" {
  description = "The ID of the virtual network."
  value       = azapi_resource.virtual_network.id
}
