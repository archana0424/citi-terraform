resource "google_compute_snapshot" "boot_snapshot" {
  name        = var.snapshot_name
  source_disk = var.source_disk   # pass boot disk self_link
}

resource "google_compute_instance" "vm_from_snapshot" {
  name         = var.new_vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      source_snapshot = google_compute_snapshot.boot_snapshot.self_link
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
    access_config {}
  }
}