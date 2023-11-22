variable "namespace" {
  description = "Namespace for the issuer and certificate"
  type        = string
}

variable "issuer_name" {
  description = "Name of the issuer"
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

variable "certificate_name" {
  description = "Name of the certificate"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "dns_names" {
  description = "List of DNS names"
  type        = list(string)
}

resource "cert-manager.io_issuer" "letsencrypt-issuer" {
  metadata {
    name      = var.issuer_name
    namespace = var.namespace
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

resource "cert-manager.io_certificate" "certificate-tls" {
  metadata {
    name      = var.certificate_name
    namespace = var.namespace
  }

  spec {
    secretName = var.secret_name

    issuerRef {
      name = var.issuer_name
    }

    dnsNames = var.dns_names
  }
}
