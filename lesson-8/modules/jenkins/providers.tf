terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  token                  = var.cluster_auth_token
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    token                  = var.cluster_auth_token
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  }
}
