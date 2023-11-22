variable "certificate_name" {
  description = "Name of the certificate"
  type        = string
}

variable "certificate_namespace" {
  description = "Namespace of the certificate"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "issuer_name" {
  description = "Name of the issuer"
  type        = string
}

variable "dns_names" {
  description = "List of DNS names"
  type        = list(string)
}


resource "cert-manager.io_certificate" "certificate-tls" {
  metadata {
    name      = var.certificate_name
    namespace = var.certificate_namespace
  }

  spec {
    secretName = var.secret_name

    issuerRef {
      name = var.issuer_name
    }

    dnsNames = var.dns_names
  }
}
