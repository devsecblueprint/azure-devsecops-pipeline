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
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.4.0"
    }
  }
}


provider "azuredevops" {
  org_service_url       = var.TFC_AZ_DEVOPS_ORG_SERVICE_URL
  personal_access_token = var.TFC_AZ_DEVOPS_PAT
}

provider "azuread" {
  tenant_id     = var.TFC_AZ_TENANT_ID
  client_id     = var.TFC_AZ_CLIENT_ID
  client_secret = var.TFC_AZ_CLIENT_PASSWORD

  use_cli = false
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  use_cli         = false
  subscription_id = var.TFC_AZ_SUBSCRIPTION_ID
  tenant_id       = var.TFC_AZ_TENANT_ID
  client_id       = var.TFC_AZ_CLIENT_ID
  client_secret   = var.TFC_AZ_CLIENT_PASSWORD
}
