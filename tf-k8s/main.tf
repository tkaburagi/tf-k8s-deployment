terraform {
  required_version = "~> 0.12"
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "tkaburagi"

    workspaces {
      name = "k8s-deployment"
    }
  }
}

provider "google" {
  credentials = var.gcp_key
  project     = "se-kabu"
  region      = "us-central1"
}

data "google_container_cluster" "primary" {
  name = "k8s-sentinel-demo-custer"
  location = "us-central1"
}

provider "kubernetes" {
  host = data.google_container_cluster.primary.endpoint
  username = data.google_container_cluster.primary.master_auth[0].username
  password = data.google_container_cluster.primary.master_auth[0].password
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  client_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].client_certificate)
  client_key = base64decode(data.google_container_cluster.primary.master_auth[0].client_key)
  load_config_file = "false"
}

resource "kubernetes_namespace" "tf-demo" {
  metadata {
    name = "tf-demo"
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec[0].selector[0].match_labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "terraform-example"
    labels = {
      app = "MyExampleApp"
    }
  }

  spec {
    replicas = 3

    strategy {
      type = "RollingUpdate"
    }

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "nginx-1-7-8"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
