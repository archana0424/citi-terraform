resource "google_compute_instance_group_manager" "mig" {
  name               = var.mig_name
  base_instance_name = var.base_instance_name
  zone               = var.zone

  version {
    instance_template = var.instance_template
  }

  target_size = var.target_size
}

resource "google_compute_autoscaler" "autoscaler" {
  name   = "${var.mig_name}-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.mig.id

  autoscaling_policy {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas

    cpu_utilization {
      target = 0.6
    }
  }
}