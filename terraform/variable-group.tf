resource "azuredevops_variable_group" "infra_variable_group" {
  project_id   = azuredevops_project.this_project.id
  name         = "Infrastructure Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name         = "ACR_NAME"
    secret_value = azurerm_container_registry.this_container_registry.name
    is_secret    = true

  }

  variable {
    name         = "ACR_SERVICE_CONNECTION"
    secret_value = azuredevops_serviceendpoint_azurecr.acr_registry_endpoint.id
    is_secret    = true
  }

  variable {
    name         = "image_repo"
    secret_value = var.fast_api_git_repo
    is_secret    = true

  }

}


resource "azuredevops_variable_group" "image_repo_variable" {
  project_id   = azuredevops_project.this_project.id
  name         = "Image Repository Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "imageRepository"
    value = ""

  }
  variable {
    name  = "containerRegistry"
    value = ""

  }

  variable {
    name  = "AZ_CONTAINER_NAME"
    value = ""

  }
}
