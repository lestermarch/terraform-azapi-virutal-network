# Tests

This directory contains subdirectories for unit and integration tests. For Terraform, unit tests refer to testing the results of `terraform plan`, and integration tests refer to testing the results of `terraform apply`. Unit tests are generally quick to run, and incur no cost. Integration tests require resources to be temporarily deployed, so can take several minutes and incur minor costs.

To run tests, run the `terraform test` command from the root of the repository, scoped to the appropriate directory:

```bash
# Run unit tests
terraform test -test-directory=tests/unit

# Run integration tests
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000" # Your Azure subscription ID
terraform init -test-directory=tests/integration
terraform test -test-directory=tests/integration
```

## WARNING: Resource Costs

Running integration tests will deploy resources to your current Azure subscription context and may incur a cost. Before running integration tests, ensure you are logged into Azure using the Azure CLI and verify your subscription context is appropriate for deploying test resources:

```bash
# View your current subscription context
az account show

# Change your subscription context
az account set -s {{ subscriptionId }}
```
