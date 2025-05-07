output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azapi_resource.nat_gateway.id
}

output "network_security_group_id" {
  description = "The ID of the Network Security Group"
  value       = azapi_resource.network_security_group.id
}

output "resource_group_id" {
  description = "The ID of the resource group into which resources will be deployed"
  value       = azapi_resource.resource_group.id
}
