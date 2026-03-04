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