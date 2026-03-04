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
variable "deploy_sa_email" {
  type = string
}

variable "vm1_name" {
  type    = string
  default = "vm-a"
}

variable "vm2_name" {
  type    = string
  default = "vm-b"
}

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

