resource "google_compute_route" "custom_route" {
  name                   = var.router_name
  network                = var.network
  dest_range             = var.dest_range
  next_hop_instance      = var.next_hop_instance
  next_hop_instance_zone = var.next_hop_instance_zone
  priority               = var.priority
}