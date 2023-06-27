output "dhcp_pools" {
  value = {
    for segment_key, segment in var.segments : segment_key => {
      pools = [
        for pool in segment.pool_ranges : {
          start_address = pool.start_address
          end_address = pool.end_address
        }
      ],
      dns_servers = segment.dns_servers,
      dhcp_mode   = segment.dhcp_mode
      listener_ip_address = segment.listener_ip_address
    }
  }
}
