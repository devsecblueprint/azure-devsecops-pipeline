



resource "azuredevops_build_definition" "this_definition" {
  project_id = azuredevops_project.this_project.id
  name       = "Terraform-FastAPI-Main"
  path       = "\\ExampleFolder"

  ci_trigger {
    use_yaml = false
  }


  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.this_git_repo.id
    branch_name = azuredevops_git_repository.this_git_repo.default_branch
    yml_path    = "azure-pipelins/azure-pipelines.yml"
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