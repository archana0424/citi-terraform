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