variable "network_name" {
  description = "VPC network name"
}

variable "rules" {
  description = "Map of firewall rules"
  type = map(object({
    name                   = string
    protocol               = string
    ports                  = list(string)
    source_ranges          = list(string)
    target_tags            = optional(list(string))
    target_service_accounts = optional(list(string))
  }))
}