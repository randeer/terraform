provider "kubectl" {
  # Same config as in kubernetes provider
}

provider "helm" {
  kubernetes {
    # Same config as in kubernetes provider
  }
}

provider "kubernetes" {
  # configuration
}

terraform {
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.1"
    }
  }
}

module "cert_manager" {
  source = "terraform-iaac/cert-manager/kubernetes"

  cluster_issuer_email                   = "admin@mysite.com"
  issuer_name                            = "cert-manager"
  issuer_kind                            = "issuer"
  namespace_name                         = "test-cert"
  cluster_issuer_private_key_secret_name = "cert-manager-private-key"

  solvers = [
    {
      http01 = {
        ingress = {
          class = "nginx"
        }
      }
    }
  ]

  certificates = {
    "my_certificate" = {
      dns_names = ["my.example.com"]
    }
  }
}
