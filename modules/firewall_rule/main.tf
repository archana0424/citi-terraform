resource "google_compute_firewall" "rules" {
  for_each = var.rules

  name    = each.value.name
  network = var.network_name

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

  source_ranges             = each.value.source_ranges
  target_tags               = lookup(each.value, "target_tags", [])
  target_service_accounts   = lookup(each.value, "target_service_accounts", [])
}