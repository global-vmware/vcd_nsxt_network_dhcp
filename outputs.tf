output "dhcp_pools" {
  value = {
    for segment_key, segment in var.segments : segment_key => {
      id                  = vcd_nsxt_network_dhcp.dhcp[segment_key].id
      mode                = vcd_nsxt_network_dhcp.dhcp[segment_key].mode
      dns_servers         = vcd_nsxt_network_dhcp.dhcp[segment_key].dns_servers
      listener_ip_address = vcd_nsxt_network_dhcp.dhcp[segment_key].listener_ip_address
      lease_time          = vcd_nsxt_network_dhcp.dhcp[segment_key].lease_time
      pools = [
        for p in vcd_nsxt_network_dhcp.dhcp[segment_key].pool : {
          start_address = p.start_address
          end_address   = p.end_address
        }
      ]
    }
  }
}
