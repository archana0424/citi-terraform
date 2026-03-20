output "boot_disk_self_link" {
  value = google_compute_instance.vm.boot_disk[0].source
}