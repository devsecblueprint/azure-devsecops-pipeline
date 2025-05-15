
terraform {
  backend "remote" {
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
  }
}

provider "azuredevops" {
  org_service_url = var.org_service_url
}

