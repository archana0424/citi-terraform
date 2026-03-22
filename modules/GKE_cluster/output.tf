output "endpoint" {
  value = google_container_cluster.gke.endpoint
}
output "cluster_ca_certificate" {
  value = google_container_cluster.regional_cluster.master_auth[0].cluster_ca_certificate
}
output "cluster_name" {
  value = google_container_cluster.gke.name
}