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