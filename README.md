## DHCP Terraform Module for Routed Data Center Group Networks

This Terraform module will deploy DHCP pools into existing Data Center Group Routed Networks using the `vmware/vcd` provider. This module can be used to provision DHCP Services on multiple routed network segments.

## Requirements

| Name      | Version |
|-----------|---------|
| terraform | >= 1.2  |
| vcd       | >= 3.8.2 |

## Resources

| Name                                                             | Type      |
|------------------------------------------------------------------|-----------|
| [vcd_vdc_group](https://registry.terraform.io/providers/vmware/vcd/3.8.2/docs/data-sources/vdc_group) | data source |
| [vcd_nsxt_edgegateway](https://registry.terraform.io/providers/vmware/vcd/3.8.2/docs/data-sources/nsxt_edgegateway) | data source |
| [vcd_network_routed_v2](https://registry.terraform.io/providers/vmware/vcd/3.8.2/docs/data-sources/network_routed_v2) | data source |
| [vcd_nsxt_network_dhcp](https://registry.terraform.io/providers/vmware/vcd/3.8.2/docs/resources/nsxt_network_dhcp) | resource   |

## Inputs

| Name                          | Description                                                          | Type   | Default           | Required |
|-------------------------------|----------------------------------------------------------------------|--------|-------------------|----------|
| vdc_group_name | Name of the Data Center Group | string | `"Data Center Group Name Format: <Account_Number>-<Region>-<Account_Name> <datacenter group>"` | yes |
| vdc_org_name | Name of the Data Center Group Organization | string | `"Data Center Group Name Format: <Account_Number>-<Region>-<Account_Name>"` | yes |
| vdc_edge_name | Name of the NSX-T Edge Gateway | string | `"Edge Gateway Name Format: <Account_Number>-<Region>-<Edge_GW_Identifier>-<edge>"` | yes |
| dhcp_mode | DHCP service mode. Valid values are "EDGE" (default), "NETWORK" or "RELAY". | string | "EDGE" | no |
| listener_ip_address | A map of DHCP listener IP addresses | string | null | no |
| lease_time | DHCP lease time in seconds. | string | "2592000" | no |
| dns_servers | A list of DNS server IP addresses to be assigned by this DHCP service. Maximum two values. | list(string) | null | yes |
| segments | A map of network segments to configure DHCP on. The key is the name of the network segment and the value is a map of the segment properties. Valid segment properties are "gateway" (required), "prefix_length" (required), "dns_suffix" (required), "listener_ip_address" (optional), "pool_ranges" (optional). | map(object({ gateway = string, prefix_length = number, dns_suffix = string, listener_ip_address = string, pool_ranges = list(map(string)) })) | `{"Segment-01" = {gateway = "192.168.0.1", prefix_length = 24, dns_suffix = "domain.com", listener_ip_address = null, pool_ranges = [{start_address = "192.168.0.101", end_address = "192.168.0.200"}]}, "Segment-02" = {gateway = "192.168.1.1", prefix_length = 24, dns_suffix = "domain.com", listener_ip_address = null, pool_ranges = [{start_address = "192.168.1.101", end_address = "192.168.1.200"}]}}` | yes |

`NOTE:` Each object in the `segments` map must have the following attributes:

`gateway`: The gateway IP address for the segment.
`prefix_length`: The CIDR notation prefix length for the segment.
`dns_suffix`: The DNS suffix for the segment.
`listener_ip_address` (optional): The IP address of the DHCP listener for the segment. Listener IP Address is required when your are using the "NETWORK" DHCP Mode Only.
`pool_ranges` (optional): A list of IP address ranges to be used for DHCP pools in the segment. If not specified, the module will automatically calculate a pool based on

## Outputs

| Name         | Description             |
|--------------|-------------------------|
| dhcp_pools | A map of DHCP pool ranges by segment name. |
| dhcp_dns_servers | The DNS server IP addresses assigned by this DHCP service. |
| dhcp_listener_ips | A map of DHCP listener IP addresses by segment name. |
| dhcp_mode | DHCP service mode. |

## Example Usage

This is an example of a `main.tf` file that uses the `vcd_nsxt_network_dhcp` module to configure DHCP Services on Two Data Center Group Routed Networks that are using "EDGE" DHCP Mode in a VMware Cloud Director environment:

```terraform
module "vcd_nsxt_network_dhcp" {
  source                    = "github.com/global-vmware/vcd_nsxt_network_dhcp.git?ref=v1.1.0"
  
  vdc_org_name              = "<US1-VDC-ORG-NAME>"
  vdc_group_name            = "<US1-VDC-GRP-NAME>"
  vdc_edge_name             = "<US1-VDC-EDGE-NAME>"

  dhcp_mode                 = "EDGE"

  dns_servers               = ["192.168.255.228"]

  segments = {
    "US1-Segment-01" = {
        gateway             = "172.16.0.1"
        prefix_length       = 24
        dns_suffix          = "mydomain.com"
        listener_ip_address = ""
        pool_ranges         = [
        {
            start_address   = "172.16.0.101"
            end_address     = "172.16.0.200"
        }
        ]    
    },
    "US1-Segment-02" = {
      gateway             = "172.16.1.1"
      prefix_length       = 24
      dns_suffix          = "mydomain.com"
      listener_ip_address = ""
      pool_ranges         = [
        {
            start_address = "172.16.1.101"
            end_address   = "172.16.1.200"
        }
      ]    
    }
  }
}
```