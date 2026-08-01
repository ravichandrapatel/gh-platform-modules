<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content"></a> [content](#input\_content) | The JSON content of the policy. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | A description of the policy. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the policy. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the policy. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of policy. One of SERVICE\_CONTROL\_POLICY, TAG\_POLICY, BACKUP\_POLICY, or AISERVICES\_OPT\_OUT\_POLICY. | `string` | `"SERVICE_CONTROL_POLICY"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the policy. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the policy. |
<!-- END_TF_DOCS -->