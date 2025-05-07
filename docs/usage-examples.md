# Usage Examples

This page contains example configurations for module usage.

## 1. Minimal Deployment

The minimum set of inputs required for provisioning a virtual network and subnet:

```terraform
module "network" {
  source = "..."

  address_space = "10.99.0.0/24"

  subnets = [
    {
      name = "AlphaSubnet"
      size = 26
    }
  ]
}
```

The above configuration will create a virtual network of size `/24` with a single `/26` subnet named `AlphaSubnet`. The remaining address space in the virutal network will remain unused, effectively reserved for future expansion:

<table cellspacing="0" cellpadding="2">
  <thead>
    <tr>
      <th>Subnet Name</th>
      <th>Subnet Address</th>
      <th>Subnet Range</th>
      <th colspan="3">Breakdown</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>AlphaSubnet</td>
      <td>10.99.0.0/26</td>
      <td>10.99.0.0 - 10.99.0.63</td>
      <td rowspan="1" colspan="1">/26</td>
      <td rowspan="2" colspan="1">/25</td>
      <td rowspan="3" colspan="1">/24</td>
    </tr>
    <tr>
      <td></td>
      <td>10.99.0.64/26</td>
      <td>10.99.0.64 - 10.99.0.127</td>
      <td rowspan="1" colspan="1">/26</td>
    </tr>
    <tr>
      <td></td>
      <td>10.99.0.128/25</td>
      <td>10.99.0.128 - 10.99.0.255</td>
      <td rowspan="1" colspan="2">/25</td>
    </tr>
  </tbody>
</table>

## 2. Reserved Subnets

In some cases, it may be desirable to reserve subnet ranges for future use or to have a high-degree of control over subnet allocation. When a subnet is named `null`, the address space will be remain unused:

```terraform
module "network" {
  source = "..."

  address_space = "10.99.0.0/24"

  subnets = [
    {
      name = "AlphaSubnet"
      size = 26
    },
    {
      name = null # Reserved
      size = 26
    },
    {
      name = "BetaSubnet"
      size = 25
    }
  ]
}
```

The above configuration will create a virtual network of size `/24`. The first `/26` subnet named `AlphaSubnet` will be provisioned, with the consecutive `/26` space being reserved. Findally, a second `/25` subnet named `BetaSubnet` will be provisioned following the reserved adderess space, filling the available space.

<table cellspacing="0" cellpadding="2">
  <thead>
    <tr>
      <th>Subnet Name</th>
      <th>Subnet Address</th>
      <th>Subnet Range</th>
      <th colspan="3">Breakdown</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>AlphaSubnet</td>
      <td>10.99.0.0/26</td>
      <td>10.99.0.0 - 10.99.0.63</td>
      <td rowspan="1" colspan="1">/26</td>
      <td rowspan="2" colspan="1">/25</td>
      <td rowspan="3" colspan="1">/24</td>
    </tr>
    <tr>
      <td></td>
      <td>10.99.0.64/26</td>
      <td>10.99.0.64 - 10.99.0.127</td>
      <td rowspan="1" colspan="1">/26</td>
    </tr>
    <tr>
      <td>BetaSubnet</td>
      <td>10.99.0.128/25</td>
      <td>10.99.0.128 - 10.99.0.255</td>
      <td rowspan="1" colspan="2">/25</td>
    </tr>
  </tbody>
</table>

## 3. Subnet Delegation

Subnets can optionally be delegated to an Azure service to allow that service to attach compute to the subnet:

```terraform
module "network" {
  source = "..."

  address_space = "10.99.0.0/24"

  subnets = [
    {
      name       = "ContainerAppSubnet"
      size       = 26
      delegation = "Microsoft.ContainerInstance/containerGroups"
    }
  ]
}
```

## 4. Service Endpoints

Subnets can optionally have service endpoints enabled to enable PaaS resources of the service endpoint type to allow only traffic from the source subnet:

```terraform
module "network" {
  source = "..."

  address_space = "10.99.0.0/24"

  subnets = [
    {
      name = "ApplicationSubnet"
      size = 26
      service_endpoints = [
        "Microsoft.KeyVault",
        "Microsoft.Storage"
      ]
    }
  ]
}
```

## 5. NAT Gateway

Subnets provisioned with this module deny outbound Internet traffic (data exfiltration) by default. One option to enable data exfiltration is to link an existing NAT Gateway to a subnet:

```terraform
resource "azapi_resource" "nat_gateway" { ... }

module "network" {
  source = "..."

  address_space = "10.99.0.0/24"

  subnets = [
    {
      name           = "ApplicationSubnet"
      size           = 26
      nat_gateway_id = azapi_resource.nat_gateway.id
    },
    {
      name = "DataSubnet"
      size = 26
    }
  ]
}
```

The above configuration will create a virtual network of size `/24`. The first `/26` subnet named `ApplicationSubnet` will be associated with the existing NAT Gateway, allowing traffic to egress to the Internet. The second `/26` subnet named `DataSubnet` will use the default configuration; preventing data exfiltration.

## 6. Network Security Group

Subnets can optionally be associated to an existing Network Security Group to permit or deny specific inbound and outbound traffic flows:

```terraform
resource "azapi_resource" "app_subnet_nsg" { ... }
resource "azapi_resource" "data_subnet_nsg" { ... }

module "network" {
  source = "..."

  address_space = "10.99.0.0/24"

  subnets = [
    {
      name                      = "ApplicationSubnet"
      size                      = 26
      network_security_group_id = azapi_resource.app_subnet_nsg.id
    },
    {
      name                      = "DataSubnet"
      size                      = 26
      network_security_group_id = azapi_resource.data_subnet_nsg.id
    }
  ]
}
```

The above configuration will create a virtual network of size `/24`. The two `/26` subnets `ApplicationSubnet` and `DataSubnet` will both be associated with their corresponding Network Security Group.

## 7. Route Table

Subnets provisioned with this module deny outbound Internet traffic (data exfiltration) by default. One option to enable data exfiltration is to link an existing Route Table to a subnet, for example to a Network Virtual Appliance or Azure Firewall:

```terraform
resource "azapi_resource" "route_table" { ... }

module "network" {
  source = "..."

  address_space = "10.99.0.0/24"

  subnets = [
    {
      name           = "ApplicationSubnet"
      size           = 26
      route_table_id = azapi_resource.route_table.id
    },
    {
      name = "DataSubnet"
      size = 26
    }
  ]
}
```

The above configuration will create a virtual network of size `/24`. The first `/26` subnet named `ApplicationSubnet` will be associated with the existing Route Table, forcing traffic to the specified next hop address. The second `/26` subnet named `DataSubnet` will use the default configuration; preventing data exfiltration.
