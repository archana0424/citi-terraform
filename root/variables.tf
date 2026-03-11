variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "vpc1_name" {
  type    = string
  default = "vpc-app-dev"
}

variable "vpc2_name" {
  type    = string
  default = "vpc-onprem-sim"
}

variable "vpc1_subnets" {
  type = map(object({
    name   = string
    cidr   = string
    region = string
  }))
}

variable "vpc2_subnets" {
  type = map(object({
    name   = string
    cidr   = string
    region = string
  }))
}

variable "vm1_name" {
  type    = string
  default = "vm-a"
}

variable "vm2_name" {
  type    = string
  default = "vm-b"
}
# vpn Variables

variable "vpc_a_asn" {
  type    = string
  description = "BGP ASN for VPC A Cloud Router"
}
variable "vpc_b_asn" {
  type    = string
  description = "BGP ASN for VPC B Cloud Router"
}

variable "vpn_shared_secret" {
  sensitive = true
}
variable "bgp_interface_cidr_a" {
  type    = string
  description = "Link-local CIDR for VPC A router interface"
}

variable "bgp_interface_cidr_b" {
  type    = string
  description = "Link-local CIDR for VPC B router interface"
}

variable "bgp_peer_ip_a" {
  type    = string
  description = "Peer IP for VPC A router interface"
}

variable "bgp_peer_ip_b" {
  type    = string
  description = "Peer IP for VPC B router interface"
}
# firewall rules Variables

variable "fw_network_name" {
  type        = string
  description = "VPC network name where firewall rules will be applied"
}
variable "deploy_sa_email" {
  type        = string
  description = "Service account email injected from Cloud Build / Secret Manager"
}
variable "fw_rules" {
  description = "Map of firewall rules for different protocols and ports"
  type = map(object({
    name                    = string
    protocol                = string
    ports                   = list(string)
    source_ranges           = list(string)
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
  }))
}

# Load Balancer Variables
variable "external_lb_name" {
  type        = string
  description = "Name of the external HTTP(S) load balancer"
  default     = "web-external-lb"
}

variable "internal_lb_name" {
  type        = string
  description = "Name of the internal TCP/UDP load balancer"
  default     = "app-internal-lb"
}

variable "external_lb_port" {
  type        = string
  description = "Port for external load balancer"
  default     = "80"
}

variable "internal_lb_port" {
  type        = string
  description = "Port for internal load balancer"
  default     = "8080"
}

variable "health_check_port" {
  type        = number
  description = "Port used for health checks"
  default     = 80
}

# cloud_dns Variables

variable "public_dns_zone_name" {
  type        = string
  description = "Name of the public DNS managed zone"
}

variable "public_dns_domain" {
  type        = string
  description = "Domain name for the public DNS zone"
}

variable "public_dns_records" {
  description = "Map of public DNS records"
  type = map(object({
    name    = string
    type    = string
    ttl     = number
    rrdatas = list(string)
  }))
}

variable "private_dns_zone_name" {
  type        = string
  description = "Name of the private DNS managed zone"
}

variable "private_dns_domain" {
  type        = string
  description = "Domain name for the private DNS zone"
}

variable "private_dns_records" {
  description = "Map of private DNS records"
  type = map(object({
    name    = string
    type    = string
    ttl     = number
    rrdatas = list(string)
  }))
}

variable "private_dns_networks" {
  type        = list(string)
  description = "List of VPC network self_links associated with private DNS zone"
}