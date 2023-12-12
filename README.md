# VCD NSX-T DHCP Terraform Module

This Terraform module deploys NSX-T DHCP Pools into an existing VMware Cloud Director (VCD) environment. This module can be used to provision new NSX-T DHCP Pools into [Rackspace Technology SDDC Flex](https://www.rackspace.com/cloud/private/software-defined-data-center-flex) VCD Data Center Regions.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2 |
| vcd | >= 3.8.2 |

## Resources

| Name                                                                 | Type         |
|----------------------------------------------------------------------|--------------|
| [vcd_nsxt_edgegateway](https://registry.terraform.io/providers/vmware/vcd/latest/docs/data-sources/nsxt_edgegateway) | Data Source |
| [vcd_vdc_group](https://registry.terraform.io/providers/vmware/vcd/latest/docs/data-sources/vdc_group) | Data Source |
| [vcd_network_routed_v2](https://registry.terraform.io/providers/vmware/vcd/latest/docs/data-sources/network_routed_v2) | Data Source |
| [vcd_nsxt_network_dhcp](https://registry.terraform.io/providers/vmware/vcd/latest/docs/resources/nsxt_network_dhcp) | Resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vdc_org_name | The name of the Data Center Group Organization in VCD | string | - | yes |
| vdc_edge_name | Name of the Data Center Group Edge Gateway | string | - | yes |
| vdc_group_name | The name of the Data Center Group in VCD | string | - | yes |
| segments | Map of network segments to configure DHCP on | map(object({ gateway = string, prefix_length = number, dns_suffix = string, listener_ip_address = string, pool_ranges = list(map(string)), dns_servers = list(string), dhcp_mode = string, lease_time = number })) | {} | yes |

## Outputs

| Name | Description |
|------|-------------|
| dhcp_pools | The pool ranges, DNS servers, DHCP mode, and listener IP address for each network segment |

## Example Usage

```terraform
module "vcd_nsxt_network_dhcp" {
  source = "github.com/global-vmware/vcd_nsxt_network_dhcp.git?ref=v2.0.1"

  vdc_org_name   = "<VDC-ORG-NAME>"
  vdc_group_name = "<VDC-GRP-NAME>"
  vdc_edge_name  = "<VDC-EDGE-NAME>"

  segments = {
    "US1-Segment-01" = {
      gateway             = "172.16.0.1"
      prefix_length       = 24
      dns_suffix          = "mydomain.com"
      listener_ip_address = "172.16.0.10"
      pool_ranges         = [
        {
          start_address   = "172.16.0.101"
          end_address     = "172.16.0.200"
        }
      ]
      dns_servers         = ["192.168.255.228"]
      dhcp_mode           = "NETWORK"
      lease_time          = 2592000
    },    
    "US1-Segment-02" = {
      gateway             = "172.16.1.1"
      prefix_length       = 24
      dns_suffix          = "mydomain.com"
      listener_ip_address = null
      pool_ranges         = [
        {
          start_address = "172.16.1.101"
          end_address   = "172.16.1.200"
        }
      ]
      dns_servers         = ["192.168.255.228"]
      dhcp_mode           = "EDGE"
      lease_time          = 2592000
    }
  }
}
```

## Authors

This module is maintained by the [Global VMware Cloud Automation Services Team](https://github.com/global-vmware).