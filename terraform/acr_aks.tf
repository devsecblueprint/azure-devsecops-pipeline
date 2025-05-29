

resource "azurerm_resource_group" "this_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "this_container_registry" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"

  depends_on = [azurerm_resource_group.this_resource_group]
}

# resource "azurerm_kubernetes_cluster" "this_aks_cluster" {
#   name                = var.aks_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   dns_prefix          = "DevSecOps-Blueprint"


#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_A2_v2"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = {
#     Environment = "Production"
#   }
#   depends_on = [azurerm_kubernetes_cluster.this_aks_cluster,
#    azurerm_resource_group.this_resource_group ]
# }

# resource "azurerm_role_assignment" "this_role_ass" {
#   principal_id                     = azurerm_kubernetes_cluster.this_aks_cluster.kubelet_identity[0].object_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.this_container_registry.id
#   skip_service_principal_aad_check = true
# }