



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
    yml_path    = ".azdo-pipelines/unit-sec-scan.yml"
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






