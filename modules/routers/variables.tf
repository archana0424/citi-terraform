variable "router_name" {
  description = "Name of the custom route"
  type        = string
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "dest_range" {
  description = "Destination CIDR range"
  type        = string
  default     = "0.0.0.0/0"
}

variable "next_hop_instance" {
  description = "Self link of the VM acting as router"
  type        = string
}

variable "next_hop_instance_zone" {
  description = "Zone of the VM acting as router"
  type        = string
}

variable "priority" {
  description = "Route priority (lower number = higher priority)"
  type        = number
  default     = 900
}