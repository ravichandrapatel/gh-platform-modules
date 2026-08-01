# IAM Role Module

Single IAM role with optional assume role policy (from trusted_entities or custom JSON), managed/custom/inline policies, and optional instance profile.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | Custom assume role policy JSON. If not provided, will be generated from trusted\_entities | `string` | `null` | no |
| <a name="input_create_instance_profile"></a> [create\_instance\_profile](#input\_create\_instance\_profile) | Whether to create an instance profile for EC2 | `bool` | `false` | no |
| <a name="input_custom_policies"></a> [custom\_policies](#input\_custom\_policies) | Map of custom IAM policies to create and attach to the role | <pre>map(object({<br/>    name        = string<br/>    description = optional(string)<br/>    path        = optional(string)<br/>    policy      = string # JSON policy document<br/>  }))</pre> | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the IAM role | `string` | `null` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | List of inline policies to embed in the role | <pre>list(object({<br/>    name   = string<br/>    policy = string # JSON policy document<br/>  }))</pre> | `[]` | no |
| <a name="input_instance_profile_name"></a> [instance\_profile\_name](#input\_instance\_profile\_name) | Name of the instance profile. Defaults to role\_name if not provided | `string` | `null` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | List of ARNs of AWS managed policies to attach to the role | `list(string)` | `[]` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration in seconds | `number` | `3600` | no |
| <a name="input_path"></a> [path](#input\_path) | Path for the IAM role and policies | `string` | `"/"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | ARN of the permissions boundary policy | `string` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_trusted_entities"></a> [trusted\_entities](#input\_trusted\_entities) | List of trusted entities that can assume this role. Used only if assume\_role\_policy is not provided | <pre>list(object({<br/>    type        = string       # Service, AWS, Federated, etc.<br/>    identifiers = list(string) # Service names, account IDs, etc.<br/>    conditions = optional(list(object({<br/>      test     = string<br/>      variable = string<br/>      values   = list(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_policy_arns"></a> [custom\_policy\_arns](#output\_custom\_policy\_arns) | ARNs of custom policies created |
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | ARN of the instance profile (if created) |
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | Name of the instance profile (if created) |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | ID of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the IAM role |
| <a name="output_role_unique_id"></a> [role\_unique\_id](#output\_role\_unique\_id) | Unique ID of the IAM role |
<!-- END_TF_DOCS -->
