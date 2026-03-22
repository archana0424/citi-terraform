resource "kubernetes_deployment" "hello_app" {
  metadata {
    name = "hello-app"
    labels = {
      app = "hello"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "hello"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "hello"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello_lb" {
  metadata {
    name = "hello-service"
  }

  spec {
    selector = {
      app = "hello"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}