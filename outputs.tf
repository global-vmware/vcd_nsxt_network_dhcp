output "dhcp_pools" {
  value = {
    for segment_key, segment in var.segments : segment_key => {
      pools = [
        for pool in segment.pool_ranges : {
          start_address = pool.start_address
          end_address = pool.end_address
        }
      ]
    }
  }
}

output "dhcp_dns_servers" {
  value = var.dhcp_mode == "RELAY" ? null : var.dns_servers
}

output "dhcp_listener_ips" {
  value = { for segment, dhcp in vcd_nsxt_network_dhcp.dhcp : segment => dhcp.listener_ip_address if var.dhcp_mode == "NETWORK" }
}


output "dhcp_mode" {
  value = var.dhcp_mode
}