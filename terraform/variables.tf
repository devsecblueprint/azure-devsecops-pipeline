
variable "tfc_azure_dynamic_credentials" {
  description = "Object containing Azure dynamic credentials configuration"
  type = object({
    default = object({
      client_id_file_path = string
      oidc_token_file_path = string
    })
    aliases = map(object({
      client_id_file_path = string
      oidc_token_file_path = string
    }))
  })
}

### Resource Group Variables ###

variable "resource_group_name" {
  type = string
  description = "name of the resource group"
  default = "fast-api-rg"
}

variable "location" {
  type = string
  description = "location of the resource group"
  default = "eastus"
  
}

### Repo Variables ###
variable "infra_git_repo" {
  type = string
  description = " of the infra git repo"

}

variable "fast_api_git_repo" {
  type = string
  description = "name of the infra git repo"
  
}
#### Azure Container Registry and Kubernetes Variables  ###

variable "acr_name" {
  type = string
  description = "name of the Azure Container Registry"
  default = "fastapidevsecopsacr"
  
}

variable "aks_name" {
  type = string
  description = "name of the Azure Kubernetes Service"
  default = "fastapidevsecopsaks"
  
}

### Azure DevOps Variables ###
variable "project_name" {
  description = "The name of the Azure DevOps project to create."
  type        = string
  default     = "DevSecOps-FastApi"

}

# variable "github_pat" {
#   type      = string
#   sensitive = true
# }

variable "org_service_url" {
  type      = string
  sensitive = true
}

variable "use_yaml"{
  description = "Bolean to determine if the pipeline should use the trigger defined in the yaml file or not"
  type        = bool
  default     = false
}