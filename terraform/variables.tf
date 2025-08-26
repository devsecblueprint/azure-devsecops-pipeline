# Default Variables
variable "TFC_AZ_CLIENT_ID" {}
variable "TFC_AZ_CLIENT_PASSWORD" {}
variable "TFC_AZ_TENANT_ID" {}
variable "TFC_AZ_SUBSCRIPTION_ID" {}
variable "TFC_AZ_DEVOPS_ORG_SERVICE_URL" {}
variable "TFC_AZ_DEVOPS_PAT" {}
variable "TFC_AZ_DEVOPS_GITHUB_PAT" {}

### Resource Group Variables ###

variable "resource_group_name" {
  type        = string
  description = "name of the resource group"
  default     = "fast-api-rg"
}

variable "location" {
  type        = string
  description = "location of the resource group"
  default     = "eastus"

}

#### Azure Container Registry and Kubernetes Variables  ###
variable "acr_name" {
  type        = string
  description = "name of the Azure Container Registry"
  default     = "fastapidevsecopsacr"

}

variable "aks_name" {
  type        = string
  description = "name of the Azure Kubernetes Service"
  default     = "fastapidevsecopsaks"

}

variable "uaid_name" {
  type        = string
  description = "name of the Azure Kubernetes Service"
  default     = "DevSecOps-User-Assigned-Identity"

}