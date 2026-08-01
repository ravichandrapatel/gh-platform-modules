<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attachments"></a> [attachments](#input\_attachments) | List of policy attachments. | <pre>list(object({<br/>    policy_key = string<br/>    target_id  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Map of policies to create. | <pre>map(object({<br/>    name        = string<br/>    content     = string<br/>    type        = string<br/>    description = optional(string)<br/>    tags        = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policies"></a> [policies](#output\_policies) | n/a |
<!-- END_TF_DOCS -->