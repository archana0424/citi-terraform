# Cloud Router
resource "google_compute_router" "nat_router" {
  name    = "${var.vpc_name}-router"
  region  = var.region
  network = var.vpc_name
}

# Cloud NAT
resource "google_compute_router_nat" "nat_config" {
  name                               = "${var.vpc_name}-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.subnet_name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}