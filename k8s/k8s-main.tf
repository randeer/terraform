terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
     #version = "2.17.0"
    }
  }
}

provider "kubernetes" {
  # Configuration options
    config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "from-terraform" {
  metadata {
    name = "from-terraform"
  }
}

resource "kubernetes_deployment" "test" {
  metadata {
    name      = "randeer-cv"
    namespace = kubernetes_namespace.from-terraform.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "MyTestApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "MyTestApp"
        }
      }
      spec {
        container {
          image = "randeerdil/cv_template:58"
          name  = "nginx-container"
          port {
            container_port = 443
          }
        }
      }
    }
  }
}

variable "test-var" {
  type = "string"
  value = "rashmika-manawadu"
}

output "k8s-image-name" {
  value = kubernetes_deployment.test.spec.0.template.0.spec.0.container.0.image
}
