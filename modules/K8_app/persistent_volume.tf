resource "kubernetes_persistent_volume_v1" "gke_pv" {

  metadata {
    name = "${var.app_name}-pv"
  }

  spec {

    capacity = {
      storage = var.pv_size
    }

    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    
    persistent_volume_source {

      gce_persistent_disk {
        pd_name = var.gce_disk_name
        fs_type = "ext4"
      }

    }

  }
}