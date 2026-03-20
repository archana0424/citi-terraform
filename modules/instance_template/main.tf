resource "google_compute_instance_template" "template" {
  name_prefix  = var.name_prefix
  machine_type = var.machine_type

  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
    access_config {}
  }

  metadata_startup_script = var.startup_script

  service_account {
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }

  tags = var.tags
}