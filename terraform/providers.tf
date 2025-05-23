terraform {
  cloud {
    organization = "DSB"

    workspaces {
      name = "azure-devsecops-pipelines"
    }
  }

  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.9.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.28.0"
    }
  }
}

provider "azuredevops" {
  org_service_url = var.org_service_url
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  use_cli              = false
  use_oidc             = true
  client_id_file_path  = var.tfc_azure_dynamic_credentials.default.client_id_file_path
  oidc_token_file_path = var.tfc_azure_dynamic_credentials.default.oidc_token_file_path
  subscription_id      = "9e3af6ab-6e22-4d23-a3ef-a6e883abe616"
  tenant_id            = "233318cd-0fbb-44eb-9437-4e2681adf87e"
}
