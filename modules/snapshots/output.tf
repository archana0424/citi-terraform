output "snapshot_name" {
  value = google_compute_snapshot.boot_snapshot.name
}

output "restored_vm_name" {
  value = google_compute_instance.vm_from_snapshot.name
}