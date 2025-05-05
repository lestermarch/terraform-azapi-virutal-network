output "resource_group_id" {
  description = "The ID of the resource group into which resources will be deployed"
  value       = azapi_resource.resource_group.id
}
