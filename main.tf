terraform {
  required_version = ">= 1.2"

  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = ">= 3.8.2"
    }
  }
}

# Create the Datacenter Group data source
data "vcd_vdc_group" "dcgroup" {
  name            = var.vdc_group_name
}

# Create the NSX-T Edge Gateway data source
data "vcd_nsxt_edgegateway" "t1" {  
  org             = var.vdc_org_name
  owner_id        = data.vcd_vdc_group.dcgroup.id
  name            = var.vdc_edge_name
}

data "vcd_network_routed_v2" "network" {
  for_each        = var.segments
  name            = each.key
  org             = var.vdc_org_name
  edge_gateway_id = data.vcd_nsxt_edgegateway.t1.id
}

resource "vcd_nsxt_network_dhcp" "dhcp" {
  for_each             = var.segments
  org                  = var.vdc_org_name
  org_network_id       = data.vcd_network_routed_v2.network[each.key].id
  mode                 = each.value.dhcp_mode
  listener_ip_address  = each.value.dhcp_mode == "NETWORK" ? each.value.listener_ip_address : null
  lease_time           = each.value.lease_time
  dns_servers          = each.value.dhcp_mode == "RELAY" ? null : each.value.dns_servers
  
  dynamic "pool" {
    for_each = each.value.dhcp_mode == "RELAY" ? [] : each.value.pool_ranges
    content {
      start_address = pool.value.start_address
      end_address   = pool.value.end_address
    }
  }
}









