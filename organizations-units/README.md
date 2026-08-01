<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_units"></a> [units](#input\_units) | Map of organizational units to create. | <pre>map(object({<br/>    name      = string<br/>    parent_id = string<br/>    tags      = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_units"></a> [units](#output\_units) | n/a |
<!-- END_TF_DOCS -->