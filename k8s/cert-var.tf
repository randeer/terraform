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

variable "cluster_issuer_email" {
  default = "admin@mysite.com"
}

variable "issuer_name" {
  default = "cert-manager"
}

variable "namespace_name" {
  default = "test-cert"
}

variable "cluster_issuer_private_key_secret_name" {
  default = "cert-manager-private-key"
}

variable "dns_names" {
  default = ["my.example.com"]
}

module "cert_manager" {
  source = "terraform-iaac/cert-manager/kubernetes"

  cluster_issuer_email                   = var.cluster_issuer_email
  issuer_name                            = var.issuer_name
  namespace_name                         = var.namespace_name
  cluster_issuer_private_key_secret_name = var.cluster_issuer_private_key_secret_name

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
      dns_names = var.dns_names
    }
  }
}
