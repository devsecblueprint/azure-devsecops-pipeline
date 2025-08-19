# Azure DevSecOps Pipeline - Terraform

![License](https://img.shields.io/github/license/devsecblueprint/azure-devsecops-pipeline?logo=license&style=for-the-badge)
![Terraform Cloud](https://img.shields.io/badge/Terraform-Registry-purple?logo=terraform&style=for-the-badge)
![GitHub Issues](https://img.shields.io/github/issues/devsecblueprint/azure-devsecops-pipeline?logo=github&style=for-the-badge)
![GitHub Forks](https://img.shields.io/github/forks/devsecblueprint/azure-devsecops-pipeline?logo=github&style=for-the-badge)
![GitHub Stars](https://img.shields.io/github/stars/devsecblueprint/azure-devsecops-pipeline?logo=github&style=for-the-badge)
![GitHub Last Commit](https://img.shields.io/github/last-commit/devsecblueprint/azure-devsecops-pipeline?logo=github&style=for-the-badge)
![CI Status](https://img.shields.io/github/actions/workflow/status/devsecblueprint/azure-devsecops-pipeline/main.yml?style=for-the-badge&logo=github)

## Overview

This project provides an automated **DevSecOps pipeline** for deploying and securing infrastructure on **Azure** using **Terraform** and **Terraform Cloud**. The pipeline is defined in `azure-pipelines.yml` and leverages reusable templates under `.azdo-pipelines/pipeline_templates/` for modular, secure, and maintainable builds.

## Requirements

- **Terraform** (latest stable version)
- **Terraform Cloud** account
- **Azure** subscription with appropriate RBAC permissions
- **Azure DevOps** account for running pipelines

## Pipeline Workflow

The main pipeline (`azure-pipelines.yml`) orchestrates the following stages:

1. **Build Docker Image**  
   Uses [`build-image.yml`](.azdo-pipelines/pipeline_templates/build-image.yml) to build container images from source code using Azure DevOps agents.

2. **Lint and Format**  
   Uses [`linting.yml`](.azdo-pipelines/pipeline_templates/linting.yml) to enforce Python code formatting and linting (Python 3.12.6 by default).

3. **Unit & Security Testing**  
   Uses [`unit-sec-scan.yml`](.azdo-pipelines/pipeline_templates/unit-sec-scan.yml) to run unit tests and basic security checks before publishing artifacts.

4. **Push Docker Image**  
   Uses [`push-image.yml`](.azdo-pipelines/pipeline_templates/push-image.yml) to push the validated image to Azure Container Registry (ACR).

## Repository Structure

```bash
.azdo-pipelines/
  ├── azure-pipelines.yml             # Main Azure DevOps pipeline
  └── pipeline_templates/             # Modular templates
       ├── build-image.yml            # Build container images
       ├── linting.yml                # Code linting & formatting
       ├── push-image.yml             # Push image to ACR
       ├── sample-push.yml            # Example template for image push
       └── unit-sec-scan.yml          # Unit + security testing

terraform/
  ├── main.tf                         # Core Terraform configuration
  ├── acr_aks.tf                      # Azure Container Registry + AKS
  ├── providers.tf                    # Provider configuration
  ├── variables.tf                    # Input variables
  ├── variable-group.tf               # Variable groups integration
  └── outputs.tf                      # Outputs
```

## Setup Instructions

### 1. **Terraform Cloud Setup**

- Create an account on [Terraform Cloud](https://app.terraform.io/).
- Generate an API key and store it in Azure DevOps as a secure variable.
- Create workspaces for your infrastructure modules.

### 2. **Configure Azure Credentials**

- Follow [Terraform Dynamic Provider Credentials](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/azure-configuration).
- Ensure your Service Principal or Managed Identity has proper roles (Contributor, AcrPush, AKS permissions).

### 3. **Initialize Terraform**

From the `terraform/` folder:

```bash
terraform init
terraform plan
```

### 4. **Run the Pipeline**

- Connect your repository to Azure DevOps.
- Trigger the pipeline defined in `.azdo-pipelines/azure-pipelines.yml`.

## Environment Variables

Configure the following in **Terraform Cloud** or **Azure DevOps Variable Groups**:

- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

## References

- [Deploy Azure Infrastructure using Terraform Cloud](https://dev.to/this-is-learning/deploy-azure-infrastructure-using-terraform-cloud-3j9d)
- [Terraform Cloud: Dynamic Provider Credentials for Azure](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/azure-configuration#configure-hcp-terraform)
