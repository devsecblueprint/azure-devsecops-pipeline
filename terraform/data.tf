data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azuread_client_config" "current" {}
