<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_route_table_ids"></a> [accepter\_route\_table\_ids](#input\_accepter\_route\_table\_ids) | Route table IDs in the accepter VPC to add routes to the requester VPC. | `list(string)` | `[]` | no |
| <a name="input_allow_remote_vpc_dns_resolution"></a> [allow\_remote\_vpc\_dns\_resolution](#input\_allow\_remote\_vpc\_dns\_resolution) | Enable private DNS resolution across the peering for both requester and accepter (resolve the peer VPC's private hosted zone names). Requires the peering to be active/auto-accepted. | `bool` | `false` | no |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | Accept the peering (both VPCs need to be in the same AWS account). | `bool` | `true` | no |
| <a name="input_peer_cidr_block"></a> [peer\_cidr\_block](#input\_peer\_cidr\_block) | The CIDR block of the peer VPC. | `string` | n/a | yes |
| <a name="input_peer_vpc_id"></a> [peer\_vpc\_id](#input\_peer\_vpc\_id) | The ID of the VPC with which you are creating the peering connection. | `string` | n/a | yes |
| <a name="input_requester_route_table_ids"></a> [requester\_route\_table\_ids](#input\_requester\_route\_table\_ids) | Route table IDs in the requester VPC to add routes to the peer VPC. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block of the requester VPC. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the requester VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accept_status"></a> [accept\_status](#output\_accept\_status) | The status of the VPC Peering Connection request. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the VPC Peering Connection. |
<!-- END_TF_DOCS -->