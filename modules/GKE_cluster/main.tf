resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region
  network    = var.network
  subnetwork = var.subnet
  remove_default_node_pool = true
  initial_node_count       = 1
  ip_allocation_policy {}
}
