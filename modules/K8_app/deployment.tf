resource resource "kubernetes_deployment_v1" "hello_app" {

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
          # Mount volume inside container
          volume_mount {
            name       = "app-storage"
            mount_path = "/data"
          }
        }

        # Attach PVC to pod
        volume {

          name = "app-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.gke_pvc.metadata[0].name
          }
        }
      }
    }
  }
}