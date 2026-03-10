variable "zone_name" {
  type        = string
  description = "Name of the DNS managed zone"
}

variable "zone_domain" {
  type        = string
  description = "Domain name for the DNS zone (must end with a dot)"
}

variable "zone_visibility" {
  type        = string
  description = "Visibility of the zone: public or private"
}

variable "records" {
  description = "Map of DNS records"
  type = map(object({
    name    = string
    type    = string
    ttl     = number
    rrdatas = list(string)
  }))
}

variable "private_networks" {
  type        = list(string)
  description = "List of VPC network self_links for private zones"
  default     = []
}