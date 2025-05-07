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
      name = "BasicSubnet"
      size = 26
    }
  ]
}
```

The above configuration will create a virtual network of size `/24` with a single `/26` subnet named `BasicSubnet`. The remaining address space in the virutal network will remain unused, effectively reserved for future expansion:

<table class="calc" cellspacing="0" cellpadding="2">
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
      <td>BasicSubnet</td>
      <td>10.99.0.0/26</td>
      <td>10.99.0.0 - 10.99.0.63</td>
      <td rowspan="1" colspan="1">/26</td>
      <td rowspan="2" colspan="1">/25</td>
      <td rowspan="3" colspan="1">/24</td>
    </tr>
    <tr>
      <td><i>Unused</i></td>
      <td>10.99.0.64/26</td>
      <td>10.99.0.64 - 10.99.0.127</td>
      <td rowspan="1" colspan="1">/26</td>
    </tr>
    <tr>
      <td><i>Unused</i></td>
      <td>10.99.0.128/25</td>
      <td>10.99.0.128 - 10.99.0.255</td>
      <td rowspan="1" colspan="2">/25</td>
    </tr>
  </tbody>
</table>

## 2. Reserved Subnets
