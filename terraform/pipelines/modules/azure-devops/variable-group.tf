

resource "azuredevops_variable_group" "credentials_group" {
  project_id   = azuredevops_project.this_project.id
  name         = "Infrastructure Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "AZ_SUBSCRIPTION_ID"
    secret_value = "this-is-a-secret-value"
    is_secret = true

  }
  variable {
    name  = "AZ_TENANT_ID"
    # secret_value = 
    # is_secret = true

  }

  variable {
    name  = "AZ_CLIENT_ID"
    # secret_value = 
    # is_secret = true

  }

}


resource "azuredevops_variable_group" "backend_group" {
  project_id   = azuredevops_project.this_project.id
  name         = "Backend Azure variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "AZ_RESOURCE_GROUP"
    value = ""

  }
  variable {
    name  = "AZ_STORAGE_ACCOUNT"
    value = ""

  }

  variable {
    name  = "AZ_CONTAINER_NAME"
    value = ""

  }

}
