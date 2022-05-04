terraform {
  required_version = ">= 0.14"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.10.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}
