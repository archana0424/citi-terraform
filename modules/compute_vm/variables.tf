variable "name" {
  type = string
}

variable "zone" {
  type = string
}

variable "network" {
  type = string
}

variable "subnet" {
  type = string
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "sa_email" {
  type = string
}

variable "startup_script" {
  type = string
}

variable "image" {
  type = string
}

variable "machine_type" {
  type = string
}