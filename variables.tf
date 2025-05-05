variable "address_space" {
  description = "The CIDR range to assign as the root address space for the virtual network."
  nullable    = false
  type        = string
}

variable "location" {
  description = "The region into which resources will be deployed."
  nullable    = false
  type        = string
}

variable "name" {
  default     = null
  description = "The name of the virtual network."
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group into which resources will be deployed."
  nullable    = false
  type        = string
}

variable "resource_tags" {
  default     = null
  description = "A map of key-value pairs to use as resource tags."
  type        = map(string)
}

variable "subnets" {
  description = <<-EOT
  A list of objects defining the subnets to create, in the format:
  ```
  [
    {
      name = "SimpleSubnet"
      size = 26
    },
    {
      name       = "DelegatedSubnet"
      size       = 26
      delegation = "Microsoft.ContainerInstance/containerGroups"
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
  ```
  EOT
  nullable    = false
  type = list(object({
    name                                         = string
    size                                         = number
    delegation                                   = optional(string)
    enable_private_endpoint_network_policies     = optional(bool, false)
    enable_private_link_service_network_policies = optional(bool, true)
    service_endpoints                            = optional(list(string), [])
  }))
}
