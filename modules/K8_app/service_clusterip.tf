resource "kubernetes_service_v1" "clusterip" {

  metadata {
    name = "${var.app_name}-clusterip"
  }

  spec {

    selector = {
      app = var.app_label
    }

    port {
      port        = var.service_port
      target_port = var.container_port
    }

    type = "ClusterIP"
  }
}