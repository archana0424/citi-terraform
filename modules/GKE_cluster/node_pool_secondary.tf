resource "google_container_node_pool" "secondary_pool" {

  name     = "${var.cluster_name}-secondary"
  cluster  = google_container_cluster.gke.name
  location = var.region

  node_config {

    machine_type    = var.secondary_machine_type
    service_account = var.sa_email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  autoscaling {
    min_node_count = var.secondary_min_nodes
    max_node_count = var.secondary_max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

}