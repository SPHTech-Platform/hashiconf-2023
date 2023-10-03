terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.48"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.18"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "~> 1.1.0"
    }
  }

  # Backend configuration here
}
