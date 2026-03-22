resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region
  network    = var.network
  subnetwork = var.subnet
  remove_default_node_pool = true
  initial_node_count       = 1
  ip_allocation_policy {}
}

resource "google_container_node_pool" "nodes" {
  name       = "${var.cluster_name}-pool"
  cluster    = google_container_cluster.gke.name
  location   = var.region
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    service_account = var.deploy_sa_email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}