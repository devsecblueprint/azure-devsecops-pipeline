


### Create a new Azure DevOps project
resource "azuredevops_project" "this_project" {
    name = var.project_name
    visibility = "public"
    version_control = "Git"
    work_item_template = "Agile"
    description = "This project is managed and Created by Terraform"
    features = {
      testplans = "disabled"
      artifacts = "enabled"
    
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
    azuredevops_variable_group.backend_group.id,
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
