resource "azuredevops_variable_group" "infra_variable_group" {
  project_id   = azuredevops_project.this.id
  name         = "Infrastructure Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "ACR_URL"
    value = azurerm_container_registry.this_container_registry.login_server

  }

  variable {
    name  = "ACR_SERVICE_CONNECTION"
    value = azuredevops_serviceendpoint_azurecr.acr_registry_endpoint.id
  }
}
