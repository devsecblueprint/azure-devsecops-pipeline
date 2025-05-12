terraform { 
  cloud {    
    organization = "DSB" 

    workspaces { 
      name = "azure-devsecops-pipelines" 
    } 
  } 
}

provider "azurerm" {
  features {}
  // use_cli should be set to false to yield more accurate error messages on auth failure.
  use_cli              = false
  // use_oidc must be explicitly set to true when using multiple configurations.
  use_oidc             = true
  client_id_file_path  = var.tfc_azure_dynamic_credentials.default.client_id_file_path
  oidc_token_file_path = var.tfc_azure_dynamic_credentials.default.oidc_token_file_path
  subscription_id = "9e3af6ab-6e22-4d23-a3ef-a6e883abe616"
  tenant_id            = "233318cd-0fbb-44eb-9437-4e2681adf87e"
}