/*  Classic VPN Setup (Static Routes)
Limitation: single gateway, no redundancy, routes must be defined manually.
# VPN Gateway
resource "google_compute_vpn_gateway" "gateway" {
  name    = "${var.vpn_gateway_name}-gateway"
  network = var.vpc_self_link   # comes from VPC module output
  region  = var.region
}

# External IP for the gateway
resource "google_compute_address" "address" {
  name   = "${var.vpn_gateway_name}-ip"
  region = var.region
}

# VPN Tunnel
resource "google_compute_vpn_tunnel" "tunnel" {
  name               = "${var.vpn_gateway_name}-tunnel"
  region             = var.region
  target_vpn_gateway = google_compute_vpn_gateway.gateway.id
  peer_ip            = var.peer_ip   # comes from OTHER vpn module output
  shared_secret      = var.shared_secret

  local_traffic_selector  = [var.local_cidr]
  remote_traffic_selector = [var.remote_cidr]
}

# Route to remote network
resource "google_compute_route" "route" {
  name       = "${var.vpn_gateway_name}-route"
  network    = var.vpc_name
  dest_range = var.remote_cidr
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel.id
}
*/
# HA VPN Gateway
resource "google_compute_ha_vpn_gateway" "gateway" {
  name    = "${var.name}-gw"
  network = var.vpc_self_link
  region  = var.region
}

# External VPN Gateway (peer side)
resource "google_compute_external_vpn_gateway" "peer" {
  name            = "${var.name}-peer"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  interface {
    id         = 0
    ip_address = var.peer_gateway_ip
  }
}

# Cloud Router
resource "google_compute_router" "router" {
  name    = "${var.name}-cr"
  region  = var.region
  network = var.vpc_self_link

  bgp {
    asn = var.local_asn
  }
}

# VPN Tunnel
resource "google_compute_vpn_tunnel" "tunnel" {
  name                            = "${var.name}-tunnel"
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gateway.id
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.peer.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.shared_secret
  ike_version                     = 2
  router                          = google_compute_router.router.name
}

# Router Interface
resource "google_compute_router_interface" "interface" {
  name       = "${var.name}-int0"
  router     = google_compute_router.router.name
  region     = var.region
  ip_range   = var.bgp_interface_cidr_local
  vpn_tunnel = google_compute_vpn_tunnel.tunnel.name
}

# Router Peer (BGP session)
resource "google_compute_router_peer" "peer" {
  name            = "${var.name}-peer0"
  router          = google_compute_router.router.name
  region          = var.region
  peer_asn        = var.peer_asn
  interface       = google_compute_router_interface.interface.name
  peer_ip_address = var.bgp_interface_peer_ip
  advertise_mode  = "DEFAULT"
}