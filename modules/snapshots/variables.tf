variable "snapshot_name" {
  description = "Snapshot name"
  type        = string
}

variable "source_disk" {
  description = "Boot disk self link"
  type        = string
}

variable "new_vm_name" {
  description = "New VM created from snapshot"
  type        = string
}

variable "machine_type" {
  description = "Machine type"
  type        = string
}

variable "zone" {
  description = "VM zone"
  type        = string
}

variable "network" {
  description = "VPC network"
  type        = string
}

variable "subnet" {
  description = "Subnetwork"
  type        = string
}

variable "sa_email" {
  description = "Service account email"
  type        = string
}