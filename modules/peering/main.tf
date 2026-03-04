resource "google_compute_network_peering" "local_to_peer" {
  name                  = "${var.local_vpc_name}-to-${var.peer_vpc_name}"
  network               = var.local_vpc_self_link
  peer_network          = var.peer_vpc_self_link
  export_custom_routes  = true
  import_custom_routes  = true
}

resource "google_compute_network_peering" "peer_to_local" {
  name                  = "${var.peer_vpc_name}-to-${var.local_vpc_name}"
  network               = var.peer_vpc_self_link
  peer_network          = var.local_vpc_self_link
  export_custom_routes  = true
  import_custom_routes  = true
}