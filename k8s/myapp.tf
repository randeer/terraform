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
}

variable "namespace_name" {}
variable "email" {}
variable "private_key_secret_ref" {}

resource "kubernetes_namespace" "resource_name" {
  metadata {
    name = var.namespace_name
  }
}

resource "time_sleep" "wait_for_issuer" {
    depends_on = [kubernetes_namespace.resource_name]
    create_duration = "10s"
}

resource "kubectl_manifest" "issuer" {
  depends_on = [time_sleep.wait_for_issuer]
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: issuer-myapp
  namespace: var.namespace_name
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: var.email
    privateKeySecretRef:
      name: var.private_key_secret_ref
    solvers:
    - selector: {}
      http01:
        ingress:
          ingressClassName: nginx
YAML
}
