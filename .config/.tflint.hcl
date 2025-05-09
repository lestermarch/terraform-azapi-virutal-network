plugin "terraform" {
  # https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/README.md#rules
  enabled = true
  preset  = "all"
}

plugin "azurerm" {
  # https://github.com/terraform-linters/tflint-ruleset-azurerm/blob/master/docs/README.md#rules
  enabled = true
  version = "0.26.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_deprecated_interpolation" {
  enabled = false
}
