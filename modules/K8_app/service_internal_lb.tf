resource "kubernetes_service" "internal_lb" {

  metadata {
    name = "${var.app_name}-internal"

    annotations = {
      "cloud.google.com/load-balancer-type" = "Internal"
    }
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