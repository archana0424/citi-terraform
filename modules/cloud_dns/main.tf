resource "google_dns_managed_zone" "dns_zone" {
  name        = var.zone_name
  dns_name    = var.zone_domain
  description = "Managed DNS zone"

  visibility  = var.zone_visibility # "public" or "private"

  private_visibility_config {
  dynamic "networks" {
    for_each = var.private_networks
    content {
      network_url = networks.value
    }
  }
}

resource "google_dns_record_set" "records" {
  for_each = var.records

  managed_zone = google_dns_managed_zone.dns_zone.name
  name         = "${each.value.name}.${var.zone_domain}"
  type         = each.value.type
  ttl          = each.value.ttl
  rrdatas      = each.value.rrdatas
}