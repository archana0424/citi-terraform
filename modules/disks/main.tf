resource "google_compute_disk" "extra_disk" {
  name = var.disk_name
  size = var.disk_size
  zone = var.zone
}

resource "google_compute_attached_disk" "attach_disk" {
  disk     = google_compute_disk.extra_disk.id
  instance = var.vm_name
  zone = var.zone
}