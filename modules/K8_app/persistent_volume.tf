resource "kubernetes_persistent_volume" "gke_pv" {

  metadata {
    name = "${var.app_name}-pv"
  }

  spec {

    capacity = {
      storage = var.pv_size
    }

    access_modes = ["ReadWriteOnce"]

    persistent_volume_reclaim_policy = "Retain"

    gce_persistent_disk {
      pd_name = var.gce_disk_name
      fs_type = "ext4"
    }
  }
}