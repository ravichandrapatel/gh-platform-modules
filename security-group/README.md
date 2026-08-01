# Security Group Module

Single security group with configurable ingress and egress via **dynamic blocks** (no separate rule resources). Optional default egress rule. Tags passed by caller. **Note:** `ingress_rules` and `egress_rules` are maps (key = unique rule id) for stable iteration in dynamic blocks.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_default_egress"></a> [create\_default\_egress](#input\_create\_default\_egress) | Create default egress rule (allow all outbound) when no egress\_rules provided | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the security group | `string` | `"Managed by Terraform"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | Map of egress rules (key = unique rule id). Rendered as dynamic egress blocks on the security group. | <pre>map(object({<br/>    from_port                     = number<br/>    to_port                       = number<br/>    protocol                      = string<br/>    cidr_blocks                   = optional(list(string), [])<br/>    ipv6_cidr_blocks              = optional(list(string), [])<br/>    destination_security_group_id = optional(string, "")<br/>    self                          = optional(bool, false)<br/>    description                   = optional(string, "")<br/>  }))</pre> | `{}` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | Map of ingress rules (key = unique rule id). Rendered as dynamic ingress blocks on the security group. | <pre>map(object({<br/>    from_port                = number<br/>    to_port                  = number<br/>    protocol                 = string<br/>    cidr_blocks              = optional(list(string), [])<br/>    ipv6_cidr_blocks         = optional(list(string), [])<br/>    source_security_group_id = optional(string, "")<br/>    self                     = optional(bool, false)<br/>    description              = optional(string, "")<br/>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the security group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the security group | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the security group will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the security group |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the security group |
| <a name="output_security_group_vpc_id"></a> [security\_group\_vpc\_id](#output\_security\_group\_vpc\_id) | VPC ID of the security group |
<!-- END_TF_DOCS -->
