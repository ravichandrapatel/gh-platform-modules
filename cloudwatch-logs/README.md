# CloudWatch Logs Module

Single CloudWatch Log Group with configurable retention, KMS encryption, skip_destroy, and log class (Standard / Infrequent Access). Tags passed by caller.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | ARN or ID of the KMS key to use for encrypting log data. Omit for default encryption. | `string` | `null` | no |
| <a name="input_log_group_class"></a> [log\_group\_class](#input\_log\_group\_class) | Log class: STANDARD (default) or INFREQUENT\_ACCESS. Cannot be changed after creation. | `string` | `"STANDARD"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the log group. Either name or name\_prefix must be set (not both). | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with this prefix. Either name or name\_prefix must be set. | `string` | `null` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Number of days to retain log events. Allowed values: 0 (never expire), 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653. Omit or set to null for no expiration. | `number` | `null` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | If true, Terraform will remove the log group from state on destroy instead of deleting it in AWS. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the log group. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the log group. |
| <a name="output_id"></a> [id](#output\_id) | ID (name) of the log group. |
| <a name="output_name"></a> [name](#output\_name) | Name of the log group. |
<!-- END_TF_DOCS -->
