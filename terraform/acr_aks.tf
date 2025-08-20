resource "azurerm_resource_group" "this_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "this_container_registry" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.this_resource_group.name
  location            = var.location
  sku                 = "Standard"

  depends_on = [azurerm_resource_group.this_resource_group]
}

# resource "azurerm_kubernetes_cluster" "this_aks_cluster" {
#   name                = var.aks_name
#   location            = var.location
#   resource_group_name = azurerm_resource_group.this_resource_group.name
#   dns_prefix          = "DSB"


#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_A2_v2"
#   }

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.this_uaid.id]
#   }

#   tags = {
#     Environment = "Production"
#   }
#   depends_on = [
#     azurerm_role_assignment.uaid_contributor,
#     azurerm_role_assignment.acr_pull,
#     azurerm_role_assignment.acr_push
#   ]
# }

