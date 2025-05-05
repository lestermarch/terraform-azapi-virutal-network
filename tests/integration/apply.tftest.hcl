run "dependencies" {
  command = apply

  module {
    source = "./tests/integration/dependencies"
  }

  variables {
    location = "uksouth"
  }
}

run "apply" {
  command = apply

  variables {
    address_space     = "10.99.0.0/24"
    location          = "uksouth"
    resource_group_id = run.dependencies.resource_group_id

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
}
