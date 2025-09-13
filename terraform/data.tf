data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azuread_client_config" "current" {}
