


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

resource "azuredevops_git_repository" "this_git_repo" {
    project_id = azuredevops_project.this_project.id
    name = "FastAPi-Test"

    initialization {
        init_type = "Import"
        source_type = "Git"
        source_url = "https://github.com/thogue12/azure-devsecops-pipeline.git"
        # service_connection_id = azuredevops_serviceendpoint_github.this_github.id
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
