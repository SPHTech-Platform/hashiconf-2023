terraform {
  required_version = ">= 1.0"

  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4"
    }
    # tflint-ignore: terraform_unused_required_providers
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    # tflint-ignore: terraform_unused_required_providers
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11"
    }
  }
}
