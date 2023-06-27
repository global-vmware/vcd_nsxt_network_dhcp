variable "vdc_org_name" {}

variable "vdc_edge_name" {}

variable "vdc_group_name" {}

variable "segments" {
  type = map(object({
    gateway             = string
    prefix_length       = number
    dns_suffix          = string
    listener_ip_address = string
    pool_ranges         = list(map(string))
    dns_servers         = list(string)
    dhcp_mode           = string
    lease_time          = number
  }))
  
  description = "Map of network segments to configure DHCP on"
}
