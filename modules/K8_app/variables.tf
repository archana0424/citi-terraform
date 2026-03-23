variable "app_name" {
  description = "Application name"
  type        = string
}

variable "app_label" {
  description = "Label used for pods"
  type        = string
}

variable "image" {
  description = "Container image"
  type        = string
}

variable "replicas" {
  description = "Number of pods"
  type        = number
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "service_port" {
  description = "Service port"
  type        = number
}