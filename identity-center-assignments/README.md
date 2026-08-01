<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignments"></a> [assignments](#input\_assignments) | Map of account assignments to create. | <pre>map(object({<br/>    instance_arn       = string<br/>    permission_set_arn = string<br/>    principal_type     = string<br/>    principal_id       = string<br/>    target_id          = string<br/>    target_type        = string<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->