variable "vdc_org_name" {}

variable "vdc_edge_name" {}

variable "vdc_group_name" {}

variable "segments" {
  type = map(object({
    listener_ip_address = optional(string, null)
    pool_ranges         = optional(list(map(string)), [])
    dns_servers         = optional(list(string), ["192.168.255.228"])
    dhcp_mode           = optional(string, "EDGE")
    lease_time          = optional(number, 2592000)
  }))

  validation {
    condition = alltrue([
      for s in var.segments : (
        s.dhcp_mode == "NETWORK" ? (s.listener_ip_address != null && length(s.pool_ranges) > 0) :
        s.dhcp_mode == "EDGE" ? (s.listener_ip_address == null && length(s.pool_ranges) > 0) :
        s.dhcp_mode == "RELAY" ? (s.listener_ip_address == null && length(s.pool_ranges) == 0) : true
      )
    ])
    error_message = "Validation failed: 'NETWORK' mode requires 'listener_ip_address' and 'pool_ranges'. 'EDGE' mode requires 'pool_ranges' and MUST NOT have 'listener_ip_address'. 'RELAY' mode MUST NOT have 'listener_ip_address' or 'pool_ranges'."
  }

  description = "Map of network segments to configure DHCP on"
}
