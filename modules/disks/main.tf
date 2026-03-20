resource "google_compute_disk" "extra_disk" {
  name  = var.disk_name
  type  = "pd-standard"
  zone  = var.zone
  size  = var.disk_size
}

resource "google_compute_attached_disk" "attach_disk" {
  instance = var.vm_name
  disk     = google_compute_disk.extra_disk.name
}