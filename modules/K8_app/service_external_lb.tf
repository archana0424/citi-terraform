resource "kubernetes_service" "external_lb" {

  metadata {
    name = "${var.app_name}-external"
  }

  spec {

    selector = {
      app = var.app_label
    }

    port {
      port        = var.service_port
      target_port = var.container_port
    }

    type = "LoadBalancer"
  }
}