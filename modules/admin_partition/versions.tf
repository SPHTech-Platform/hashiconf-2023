terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
      configuration_aliases = [
        aws.a,
        aws.b,
      ]
    }
    # tflint-ignore: terraform_unused_required_providers
    consul = {
      source  = "hashicorp/consul"
      version = ">= 2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.21.1"
      configuration_aliases = [
        kubernetes.a,
        kubernetes.b,
      ]
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8"
      configuration_aliases = [
        helm.a,
        helm.b,
      ]
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = ">= 1.1"
    }
  }
}
