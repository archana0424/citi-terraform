output "disk_id" {
  value = google_compute_disk.extra_disk.id
}

output "disk_self_link" {
  value = google_compute_disk.extra_disk.self_link
}