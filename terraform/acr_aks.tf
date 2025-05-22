
resource "azurerm_resource_group" "this_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "this_acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                = var.location
    zone_redundancy_enabled = true
    tags                    = {}
  }
  georeplications {
    location                = var.location
    zone_redundancy_enabled = true
    tags                    = {}
  }
}
resource "azurerm_arc_kubernetes_cluster" "example" {
  name                         = var.aks_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  agent_public_key_certificate = filebase64("testdata/public.cer")

  identity {
    type = "SystemAssigned"
  }

  tags = {
    ENV = "Test"
  }
}