terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = ">= 2.17.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
      configuration_aliases = [
        aws.a,
        aws.b,
      ]
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.21.1"
      configuration_aliases = [
        kubernetes.a,
        kubernetes.b,
      ]
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.20"
    }
  }
}
