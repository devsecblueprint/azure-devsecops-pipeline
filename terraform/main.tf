


### Create a new Azure DevOps project
resource "azuredevops_project" "this_project" {
    name = var.project_name
    visibility = "public"
    version_control = "Git"
    work_item_template = "Agile"
    description = "This project is managed and Created by Terraform"
    features = {
      testplans = "disabled"
      artifacts = "disabled"
      boards ="disabled"
      pipelines = "enabled"
      repositories = "disabled"
    
    }
}


### Create a new Git repository

resource "azuredevops_git_repository" "infra_git_repo" {
    project_id = azuredevops_project.this_project.id
    name = "Infra-Test"

    initialization {
        init_type = "Import"
        source_type = "Git"
        source_url = "https://github.com/thogue12/azure-devsecops-pipeline.git"
        # service_connection_id = azuredevops_serviceendpoint_github.this_github.id
    }
  
}

### Create a new Git repository for FastAPI
resource "azuredevops_git_repository" "fast_api_git_repo" {
    project_id = azuredevops_project.this_project.id
    name = "FastAPI-Test"

    initialization {
        init_type = "Import"
        source_type = "Git"
        source_url = "https://github.com/thogue12/python-fastapi.git"
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
    azuredevops_variable_group.credentials_group.id,
    azuredevops_variable_group.image_repo_variable.id,
  ]

    variable {
      name = "ApplicationName"
      value = "FastAPI"

    }

    variable {
      name = "ProjetName"
      value = "Smooth-Project-Name"

    }
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

}

### Create a Service Connection to GitHub

### This only is only used for private repositories
# resource "azuredevops_serviceendpoint_github" "this_github" {
#     project_id = azuredevops_project.this_project.id
#     service_endpoint_name = "GitHub"
#     description = "Github Service Connection"

#     auth_personal {
#       personal_access_token = var.github_pat
#     }
# }
