output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azapi_resource.nat_gateway.id
}

output "resource_group_id" {
  description = "The ID of the resource group into which resources will be deployed"
  value       = azapi_resource.resource_group.id
}
