/*
variable "vpn_gateway_name" {
    type = string
}
variable "vpc_name" {
    type = string
}
variable "vpc_self_link" {
    type = string
}
variable "region" {
    type = string
}
variable "peer_ip" {
    type = string
}
variable "shared_secret" {
    type = string
}
variable "local_cidr" {
    type = string
}
variable "remote_cidr" {
    type = string
}*/
variable "name" {
    type = string
}
variable "vpc_self_link" {
    type = string
}
variable "region" {
    type = string
}
variable "peer_gateway_ip" {
    type = string
}
variable "local_asn" {
    type = string
}
variable "peer_asn" {
    type = string
}
variable "bgp_interface_cidr_local" {
    type = string
}
variable "bgp_interface_peer_ip" {
    type = string
}
variable "shared_secret" {
  sensitive = true
}