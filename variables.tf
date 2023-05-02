variable "vdc_org_name" {}

variable "vdc_edge_name" {}

variable "vdc_group_name" {}

variable "dhcp_mode" {
  type    = string
  default = "EDGE"
}

variable "listener_ip_address" {
  type    = string
  default = null
}

variable "lease_time" {
  type    = number
  default = "2592000"
}

variable "dns_servers" {
  type        = list(string)
  description = "The DNS server IPs to be assigned by this DHCP service. Maximum two values."
  default     = null
}

variable "segments" {
  type = map(object({
    gateway           = string
    prefix_length     = number
    dns_suffix        = string
    listener_ip_address = string
    pool_ranges       = list(map(string))
  }))
  
  description = "Map of network segments to configure DHCP on"
}


