output "snapshot_id" {
  value = google_compute_snapshot.boot_snapshot.id
}

output "new_vm_ip" {
  value = google_compute_instance.vm_from_snapshot.network_interface[0].access_config[0].nat_ip
}