<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability zone when target\_type is ip (optional) | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | Port on the target. Required for instance/ip; optional for lambda. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | `{}` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | ARN of the target group | `string` | n/a | yes |
| <a name="input_target_id"></a> [target\_id](#input\_target\_id) | ID of the target (instance ID, IP, or Lambda ARN depending on target\_type) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attachment_id"></a> [attachment\_id](#output\_attachment\_id) | Unique identifier for the attachment |
<!-- END_TF_DOCS -->