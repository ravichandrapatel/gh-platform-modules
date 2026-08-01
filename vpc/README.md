# VPC Module

One VPC with public/private subnets, optional IGW, NAT gateway(s), route tables, flow logs, VPN gateway, and VPC endpoints. Uses the tagging module for standard tags.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags for VPC resources | `map(string)` | `{}` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | Create an Internet Gateway for the VPC | `bool` | `true` | no |
| <a name="input_create_nat_gateway"></a> [create\_nat\_gateway](#input\_create\_nat\_gateway) | Create NAT Gateway(s) for private subnets | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | Enable VPC Flow Logs | `bool` | `false` | no |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | Create a VPN Gateway | `bool` | `false` | no |
| <a name="input_flow_logs_destination_type"></a> [flow\_logs\_destination\_type](#input\_flow\_logs\_destination\_type) | Type of flow logs destination (cloud-watch-logs or s3) | `string` | `"cloud-watch-logs"` | no |
| <a name="input_flow_logs_retention_days"></a> [flow\_logs\_retention\_days](#input\_flow\_logs\_retention\_days) | CloudWatch log retention in days for flow logs | `number` | `7` | no |
| <a name="input_flow_logs_traffic_type"></a> [flow\_logs\_traffic\_type](#input\_flow\_logs\_traffic\_type) | Type of traffic to capture (ACCEPT, REJECT, ALL) | `string` | `"ALL"` | no |
| <a name="input_nat_gateway_availability_mode"></a> [nat\_gateway\_availability\_mode](#input\_nat\_gateway\_availability\_mode) | NAT Gateway mode: zonal (per-AZ or single in a subnet) or regional (single VPC-level NAT, multi-AZ). Regional does not require public subnets for the NAT. | `string` | `"zonal"` | no |
| <a name="input_nat_gateway_per_az"></a> [nat\_gateway\_per\_az](#input\_nat\_gateway\_per\_az) | Create one NAT Gateway per AZ (true) or single NAT Gateway (false) | `bool` | `false` | no |
| <a name="input_nat_gateway_subnets"></a> [nat\_gateway\_subnets](#input\_nat\_gateway\_subnets) | Indices of public subnets to place NAT Gateways in (empty = use first subnet). Ignored when nat\_gateway\_availability\_mode is regional. | `list(number)` | `[]` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet configurations | <pre>list(object({<br/>    cidr_block        = string<br/>    availability_zone = string<br/>    name              = string<br/>  }))</pre> | `[]` | no |
| <a name="input_public_subnet_default_routes"></a> [public\_subnet\_default\_routes](#input\_public\_subnet\_default\_routes) | Optional per-public-subnet default route: "igw" (Internet Gateway) or "nat" (first zonal NAT Gateway). Must be the same length as public\_subnets when set. When null, all public subnets share one route table to the IGW (legacy behavior). | `list(string)` | `null` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnet configurations | <pre>list(object({<br/>    cidr_block        = string<br/>    availability_zone = string<br/>    name              = string<br/>  }))</pre> | `[]` | no |
| <a name="input_public_subnets_map_public_ip_on_launch"></a> [public\_subnets\_map\_public\_ip\_on\_launch](#input\_public\_subnets\_map\_public\_ip\_on\_launch) | Whether to assign public IP on launch for public subnets (set false to match existing state and avoid in-place update) | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to VPC and all created resources | `map(string)` | `{}` | no |
| <a name="input_vpc_endpoints"></a> [vpc\_endpoints](#input\_vpc\_endpoints) | Map of VPC endpoints to create. For Gateway type, use route\_table\_scope = ["private", "public"]. For Interface type, use subnet\_scope = ["private"] to use this module's subnets; leave security\_group\_ids empty to use the module-created endpoints SG. | <pre>map(object({<br/>    service_name        = string<br/>    vpc_endpoint_type   = string # Interface or Gateway<br/>    subnet_ids          = optional(list(string), [])<br/>    security_group_ids  = optional(list(string), [])<br/>    private_dns_enabled = optional(bool, true)<br/>    route_table_ids     = optional(list(string), [])<br/>    route_table_scope   = optional(list(string), []) # \"private\" and/or \"public\" — use this module's route tables (Gateway only)<br/>    subnet_scope        = optional(list(string), []) # \"private\" and/or \"public\" — use this module's subnets (Interface only)<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |
| <a name="input_vpn_gateway_asn"></a> [vpn\_gateway\_asn](#input\_vpn\_gateway\_asn) | ASN for the VPN Gateway | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_flow_logs_log_group_name"></a> [flow\_logs\_log\_group\_name](#output\_flow\_logs\_log\_group\_name) | Name of the CloudWatch log group for flow logs |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of the Internet Gateway |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | IDs of NAT Gateways |
| <a name="output_nat_gateway_public_ips"></a> [nat\_gateway\_public\_ips](#output\_nat\_gateway\_public\_ips) | Public IPs of NAT Gateways |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | IDs of private route tables |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | ARNs of private subnets |
| <a name="output_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#output\_private\_subnet\_cidr\_blocks) | CIDR blocks of private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of private subnets |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | ID of the legacy single public route table; null when using split public routing (see public\_route\_table\_ids). |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | All public-facing route table IDs (one entry in legacy mode; IGW and/or NAT tables in split mode). |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | ARNs of public subnets |
| <a name="output_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#output\_public\_subnet\_cidr\_blocks) | CIDR blocks of public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of public subnets |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | CIDR block of the VPC |
| <a name="output_vpc_endpoint_dns_entries"></a> [vpc\_endpoint\_dns\_entries](#output\_vpc\_endpoint\_dns\_entries) | DNS entries of VPC endpoints |
| <a name="output_vpc_endpoint_ids"></a> [vpc\_endpoint\_ids](#output\_vpc\_endpoint\_ids) | IDs of VPC endpoints |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC |
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | ID of the VPN Gateway |
<!-- END_TF_DOCS -->
