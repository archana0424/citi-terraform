resource "kubernetes_persistent_volume_claim" "gke_pvc" {

  metadata {
    name = "${var.app_name}-pvc"
  }

  spec {

    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = var.pv_size
      }
    }

    volume_name = kubernetes_persistent_volume.gke_pv.metadata[0].name
  }
}