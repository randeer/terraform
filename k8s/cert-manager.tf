variable "issuer_name" {
  description = "Name of the issuer"
  type        = string
}

variable "issuer_namespace" {
  description = "Namespace of the issuer"
  type        = string
}

variable "issuer_email" {
  description = "Email address used for ACME registration"
  type        = string
}

variable "private_key_secret_ref" {
  description = "Name of a secret used to store the ACME account private key"
  type        = string
}

variable "issuer_resource_name" {
  description = "Name of the cert-manager.io_issuer resource"
  type        = string
}

resource "cert-manager.io_issuer" "letsencrypt-issuer" {
  metadata {
    name      = var.issuer_name
    namespace = var.issuer_namespace
  }

  spec {
    acme {
      server = "https://acme-v02.api.letsencrypt.org/directory"
      email  = var.issuer_email

      privateKeySecretRef {
        name = var.private_key_secret_ref
      }

      solvers {
        selector = {}

        http01 {
          ingress {
            ingressClassName = "nginx"
          }
        }
      }
    }
  }
}
