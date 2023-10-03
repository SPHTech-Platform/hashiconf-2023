terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.18"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.20"
    }
  }
}
