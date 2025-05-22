# ### Creat a cert for the AKS cluster ###
# resource "tls_private_key" "agent" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }
# resource "tls_self_signed_cert" "this_agent" {
#   private_key_pem = tls_private_key.agent.private_key_pem
  

#   subject {
#     common_name  = "devsecops-agent"
#     organization = "DevSecOps blueprint"
#   }

#   validity_period_hours = 12
#   is_ca_certificate = false

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#     "client_auth"
#   ]
# }


resource "azurerm_resource_group" "this_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "this_container_registry" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
}

resource "azurerm_kubernetes_cluster" "this_aks_cluster" {
  name                = var.aks_name
  location            = var.resource_group_name
  resource_group_name = var.location
  dns_prefix          = "DevSecOps-Blueprint"


  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_role_assignment" "this_role_ass" {
  principal_id                     = azurerm_kubernetes_cluster.this_aks_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.this_container_registry.id
  skip_service_principal_aad_check = true
}