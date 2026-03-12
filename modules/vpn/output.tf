output "gateway_ip" {
  description = "Public IP of HA VPN gateway interface 0"
  value       = google_compute_ha_vpn_gateway.gateway.vpn_interfaces[0].ip_address
}