/*
 Make these into variable groups in Azure DevOps
variables:
  Container registry service connection established during pipeline creation

  dockerRegistryServiceConnection: '{{ containerRegistryConnection.Id }}'

  imageRepository: '{{#toAlphaNumericString imageRepository 50}}{{/toAlphaNumericString}}'

  containerRegistry: '{{ containerRegistryConnection.Authorization.Parameters.loginServer }}'

  dockerfilePath: '{{ dockerfilePath }}'

  tag: '$(Build.BuildId)'
*/


resource "azuredevops_variable_group" "credentials_group" {
  project_id   = azuredevops_project.this_project.id
  name         = "Infrastructure Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "imageRepository"
    secret_value = "this-is-a-secret-value"
    is_secret = true

  }
  variable {
    name  = "containerRegistry"
    # secret_value = 
    # is_secret = true

  }

  variable {
    name  = "AZ_CLIENT_ID"
    # secret_value = 
    # is_secret = true

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
