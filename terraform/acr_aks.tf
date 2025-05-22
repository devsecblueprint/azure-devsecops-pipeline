### Creat a cert for the AKS cluster ###
resource "tls_private_key" "agent" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "tls_self_signed_cert" "this_agent" {
  private_key_pem = tls_private_key.agent.private_key_pem
  

  subject {
    common_name  = "devsecops-agent"
    organization = "DevSecOps blueprint"
  }

  validity_period_hours = 12
  is_ca_certificate = false

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth"
  ]
}
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
    location                = "West Europe"
    zone_redundancy_enabled = true
    tags                    = {}
  }
  georeplications {
    location                = "North Europe"
    zone_redundancy_enabled = true
    tags                    = {}
  }
}
resource "azurerm_arc_kubernetes_cluster" "example" {
  name                         = var.aks_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  agent_public_key_certificate = tls_self_signed_cert.this_agent.cert_pem

  identity {
    type = "SystemAssigned"
  }

  tags = {
    ENV = "Test"
  }
}
