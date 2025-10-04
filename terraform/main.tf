### Create a new Azure DevOps project
resource "azuredevops_project" "this" {
  name               = "python-fastapi"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
  description        = "This project is managed and Created by Terraform"
  features = {
    testplans    = "disabled"
    artifacts    = "disabled"
    boards       = "disabled"
    pipelines    = "enabled"
    repositories = "disabled"
  }
}

### Create a new Git repository for FastAPI
resource "azuredevops_serviceendpoint_github" "this" {
  project_id            = azuredevops_project.this.id
  service_endpoint_name = "python-fastapi"

  auth_personal {
    personal_access_token = var.TFC_AZ_DEVOPS_GITHUB_PAT
  }
}

### Create Build Definition ###
resource "azuredevops_build_definition" "this" {
  project_id = azuredevops_project.this.id
  name       = "Default"

  # Let YAML in the repo control the pipeline (triggers, steps, etc.)
  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "devsecblueprint/azure-python-fastapi"
    branch_name           = "refs/heads/main"
    yml_path              = ".azdo-pipelines/azure-pipelines.yml"
    service_connection_id = azuredevops_serviceendpoint_github.this.id
  }


  variable_groups = [
    azuredevops_variable_group.infra_variable_group.id,
  ]

  variable {
    name  = "ApplicationName"
    value = "Python FastAPI"
  }
}

### Create Federated identity for Azure DevOps Pipeline ###
resource "azurerm_user_assigned_identity" "this_uaid" {
  location            = azurerm_resource_group.this_resource_group.location
  name                = var.uaid_name
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

resource "azurerm_role_assignment" "uaid_contributor" {
  principal_id         = azurerm_user_assigned_identity.this_uaid.principal_id
  role_definition_name = "Contributor"
  scope                = azurerm_container_registry.this_container_registry.id
}

resource "azurerm_federated_identity_credential" "ado_fed_id" {
  name                = "DevSecOps-Fed-Identity"
  resource_group_name = azurerm_resource_group.this_resource_group.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azuredevops_serviceendpoint_azurecr.acr_registry_endpoint.workload_identity_federation_issuer ## https://vstoken.dev.azure.com/<organization>
  parent_id           = azurerm_user_assigned_identity.this_uaid.id
  subject             = azuredevops_serviceendpoint_azurecr.acr_registry_endpoint.workload_identity_federation_subject

  depends_on = [azuredevops_build_definition.this]
}

### Create Service Connection to Azure Container Registry ###
### Authenticates the pipeline to ACR using OIDC and a User-Assigned Managed Identity ###
resource "azuredevops_serviceendpoint_azurecr" "acr_registry_endpoint" {
  project_id                             = azuredevops_project.this.id
  resource_group                         = var.resource_group_name
  service_endpoint_name                  = "AzureCR Endpoint"
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"
  azurecr_spn_tenantid                   = var.TFC_AZ_TENANT_ID
  azurecr_name                           = var.acr_name
  azurecr_subscription_id                = var.TFC_AZ_SUBSCRIPTION_ID
  azurecr_subscription_name              = var.TFC_AZ_SUBSCRIPTION_NAME

  credentials {
    serviceprincipalid = azurerm_user_assigned_identity.this_uaid.client_id
  }
}

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

  variable {
    name  = "AZURE_SERVICE_CONNECTION"
    value = azuredevops_serviceendpoint_azurerm.arm_sc.id
  }

  variable {
    name  = "RESOURCE_GROUP_NAME"
    value = azurerm_resource_group.this_resource_group.name
  }
}


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

resource "azuredevops_serviceendpoint_azurerm" "arm_sc" {
  project_id            = azuredevops_project.this.id
  service_endpoint_name = "Azure ARM Endpoint"

  environment               = "AzureCloud"
  azurerm_spn_tenantid      = var.TFC_AZ_TENANT_ID
  azurerm_subscription_id   = var.TFC_AZ_SUBSCRIPTION_ID
  azurerm_subscription_name = "DSB"

  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"

  credentials {
    serviceprincipalid = azurerm_user_assigned_identity.this_uaid.client_id
  }
}

