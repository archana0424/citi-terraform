resource "kubernetes_deployment" "hello_app" {

  metadata {
    name = var.app_name

    labels = {
      app = var.app_label
    }
  }

  spec {

    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_label
      }
    }

    template {

      metadata {
        labels = {
          app = var.app_label
        }
      }

      spec {

        container {

          name  = var.app_name
          image = var.image

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}