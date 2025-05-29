data "azuread_client_config" "current" {}


### Create a new Azure DevOps project
resource "azuredevops_project" "this_project" {
  name               = var.project_name
  visibility         = "public"
  version_control    = "Git"
  work_item_template = "Agile"
  description        = "This project is managed and Created by Terraform"
  features = {
    testplans    = "disabled"
    artifacts    = "disabled"
    boards       = "disabled"
    pipelines    = "enabled"
    repositories = "enabled"

  }
}


### Create a new Git repository

resource "azuredevops_git_repository" "infra_git_repo" {
  project_id = azuredevops_project.this_project.id
  name       = "Infra-Test"

  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = var.infra_git_repo
    # service_connection_id = azuredevops_serviceendpoint_github.this_github.id
  }

}

### Create a new Git repository for FastAPI
resource "azuredevops_git_repository" "fast_api_git_repo" {
  project_id = azuredevops_project.this_project.id
  name       = "FastAPI-Test"

  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = var.fast_api_git_repo
    # service_connection_id = azuredevops_serviceendpoint_github.this_github.id
  }

}


### Create Build Definition ###
resource "azuredevops_build_definition" "this_definition" {
  project_id = azuredevops_project.this_project.id
  name       = "Terraform-INfra-Main"
  path       = "\\Terraform"

  ci_trigger {
    use_yaml = var.use_yaml

  }


  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.infra_git_repo.id
    branch_name = "testing"
    yml_path    = ".azdo-pipelines/azure-pipelines.yml"
  }


  variable_groups = [
    azuredevops_variable_group.infra_variable_group.id,
    azuredevops_variable_group.image_repo_variable.id,
  ]

  variable {
    name  = "ApplicationName"
    value = "FastAPI"

  }

  variable {
    name  = "ProjetName"
    value = "Smooth-Project-Name"

  }
}

### Create Federated identity for Azure DevOps Pipeline ###
resource "azurerm_user_assigned_identity" "this_uaid" {
  location            = azurerm_resource_group.this_resource_group.location
  name                = "DevSecOps-User-Assigned-Identity"
  resource_group_name = azurerm_resource_group.this_resource_group.name
}

resource "azurerm_role_assignment" "acr_push" {
  principal_id         = azurerm_user_assigned_identity.this_uaid.principal_id
  role_definition_name = "AcrPush"
  scope                = azurerm_container_registry.this_container_registry.id
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_user_assigned_identity.this_uaid.principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.this_container_registry.id
}

# resource "azuread_application" "this_app" {
#   display_name     = "Az-DevSecOps-App"
#   owners           = [data.azuread_client_config.current.object_id]
# }


resource "azurerm_federated_identity_credential" "ado_fed-id" {
  name                = "DevSecOps-Fed-Identity"
  resource_group_name = azurerm_resource_group.this_resource_group.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://vstoken.dev.azure.comhttps:/thogue1267"  ## https://vstoken.dev.azure.com/<organization>
  parent_id           = azurerm_user_assigned_identity.this_uaid.id
  subject             = "sc://thogue1267/${var.project_name}:${azuredevops_serviceendpoint_azurecr.acr_registry_endpoint.id}"

  # sc://thogue1267/DevSecOps-FastApi/TimBoslice-Connection
  ## sc://<organization>/<project>/<service-connection-name> "this = subject"

  depends_on = [azuredevops_build_definition.this_definition]
}

### Create Service Connection to Azure Container Registry ###
### Authenticates the pipeline to ACR using OIDC and a User-Assigned Managed Identity ###
resource "azuredevops_serviceendpoint_azurecr" "acr_registry_endpoint" {
  project_id                             = azuredevops_project.this_project.id
  resource_group                         = var.resource_group_name
  service_endpoint_name                  = "AzureCR Endpoint"
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"
  azurecr_spn_tenantid                   = "233318cd-0fbb-44eb-9437-4e2681adf87e"
  azurecr_name                           = var.acr_name
  azurecr_subscription_id                = "9e3af6ab-6e22-4d23-a3ef-a6e883abe616"
  azurecr_subscription_name              = "DSB"

  credentials {
    serviceprincipalid = azurerm_user_assigned_identity.this_uaid.client_id
  }




}

