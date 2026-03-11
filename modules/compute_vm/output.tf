output "vm_name" {
  value = google_compute_instance.vm.name
}
output "vm_internal_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}
output "self_link" {
  value = google_compute_instance.vm.self_link
}