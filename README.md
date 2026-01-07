# VCD NSX-T DHCP Terraform Module

This Terraform module deploys NSX-T DHCP Pools into an existing VMware Cloud Director (VCD) environment. This module can be used to provision new NSX-T DHCP Pools into [Rackspace Technology SDDC Flex](https://www.rackspace.com/cloud/private/software-defined-data-center-flex) VCD Data Center Regions.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
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
| segments | Map of network segments to configure DHCP on. Attributes like `dhcp_mode` (default: "EDGE"), `lease_time` (default: 30 days), and `dns_servers` (default: ["192.168.255.228"]) have defaults. | map(object) | {} | yes |

## Validation Rules

The module includes strict validation based on the `dhcp_mode`:
- **NETWORK**: Requires `listener_ip_address` and at least one pool in `pool_ranges`.
- **EDGE**: Requires at least one pool in `pool_ranges`. MUST NOT have `listener_ip_address`.
- **RELAY**: MUST NOT have `listener_ip_address` or `pool_ranges`.

## Outputs

| Name | Description |
|------|-------------|
| dhcp_pools | Comprehensive map of deployed DHCP configurations, reading directly from resource attributes. |

## Example Usage

### Standard Deployment (EDGE Mode)
```terraform
module "vcd_nsxt_network_dhcp" {
  source = "github.com/global-vmware/vcd_nsxt_network_dhcp.git?ref=v2.1.0"

  vdc_org_name   = "<VDC-ORG-NAME>"
  vdc_group_name = "<VDC-GRP-NAME>"
  vdc_edge_name  = "<VDC-EDGE-NAME>"

  segments = {
    "Web-Network" = {
      pool_ranges = [{
        start_address = "10.0.0.100"
        end_address   = "10.0.0.200"
      }]
    }
  }
}
```

### Network Specific Deployment (NETWORK Mode)
```terraform
module "vcd_nsxt_network_dhcp" {
  source = "github.com/global-vmware/vcd_nsxt_network_dhcp.git?ref=v2.1.0"
  
  vdc_org_name   = "<VDC-ORG-NAME>"
  vdc_group_name = "<VDC-GRP-NAME>"
  vdc_edge_name  = "<VDC-EDGE-NAME>"

  segments = {
    "Isolated-Network" = {
      dhcp_mode           = "NETWORK"
      listener_ip_address = "10.1.0.10"
      pool_ranges = [{
        start_address = "10.1.0.100"
        end_address   = "10.1.0.200"
      }]
    }
  }
}
```

### Relay Deployment (RELAY Mode)
```terraform
module "vcd_nsxt_network_dhcp" {
  source = "github.com/global-vmware/vcd_nsxt_network_dhcp.git?ref=v2.1.0"
  # ... other variables ...

  segments = {
    "Shared-Network" = {
      dhcp_mode = "RELAY"
      # listener_ip_address and pool_ranges MUST be omitted
    }
  }
}
```

## Authors

This module is maintained by the [Global VMware Cloud Automation Services Team](https://github.com/global-vmware).