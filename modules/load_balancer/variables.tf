variable "lb_name" {
  type        = string
  description = "Name of the load balancer"
}

variable "lb_scheme" {
  type        = string
  description = "Load balancing scheme: EXTERNAL or INTERNAL"
}

variable "lb_port_range" {
  type        = string
  description = "Port range for the load balancer (e.g., 80, 443, 8080)"
}

variable "backend_instances" {
  type        = list(string)
  description = "List of backend instance self_links"
}

variable "network" {
  type        = string
  description = "VPC network for the load balancer"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork for internal load balancer (required if INTERNAL)"
  default     = null
}

variable "health_check_port" {
  type        = number
  description = "Port for health check"
  default     = 80
}