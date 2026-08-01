<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | Map of permission sets to create. | <pre>map(object({<br/>    instance_arn        = string<br/>    name                = string<br/>    description         = string<br/>    managed_policy_arns = list(string)<br/>    inline_policy       = optional(string)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_permission_sets"></a> [permission\_sets](#output\_permission\_sets) | n/a |
<!-- END_TF_DOCS -->