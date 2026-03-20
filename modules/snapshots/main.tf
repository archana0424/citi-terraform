resource "google_compute_snapshot" "boot_snapshot" {
  name        = var.snapshot_name
  source_disk = var.source_disk
}

resource "google_compute_disk" "disk_from_snapshot" {
  name             = "${var.new_vm_name}-disk"
  zone             = var.zone
  source_snapshot  = google_compute_snapshot.boot_snapshot.self_link
}

resource "google_compute_instance" "vm_from_snapshot" {
  name         = var.new_vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    source = google_compute_disk.disk_from_snapshot.id
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
    access_config {}
  }

  service_account {
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }
}