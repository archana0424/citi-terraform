variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for resources"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name of the VPC where NAT will be created"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet to attach NAT"
  type        = string
}