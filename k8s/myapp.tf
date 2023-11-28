terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

variable "namespace_name" {}
variable "resource_name" {}
variable "issuer_name" {}
variable "email" {}
variable "private_key_secret_ref" {}

resource "kubernetes_namespace" var.resource_name {
  metadata {
    name = var.namespace_name
  }
}

resource "cert-manager_issuer" var.resource_name {
  depends_on = [kubernetes_namespace.var.resource_name]
  apiVersion = "cert-manager.io/v1"
  kind       = "Issuer"
  metadata {
    name      = var.issuer_name
    namespace = var.namespace_name
  }
  spec {
    acme {
      server             = https://acme-v02.api.letsencrypt.org/directory
      email              = var.email
      privateKeySecretRef {
        name = var.private_key_secret_ref
      }
      solvers {
        selector = {}
        http01 {
          ingress {
            ingressClassName = nginx
          }
        }
      }
    }
  }
}
