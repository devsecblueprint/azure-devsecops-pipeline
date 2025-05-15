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