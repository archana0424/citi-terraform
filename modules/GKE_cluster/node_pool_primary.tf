resource "google_container_node_pool" "primary_pool" {

  name     = "${var.cluster_name}-primary"
  cluster  = google_container_cluster.gke.name
  location = var.region

  node_config {

    machine_type    = var.machine_type
    service_account = var.sa_email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}