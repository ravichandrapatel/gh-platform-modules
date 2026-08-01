<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_host_header"></a> [host\_header](#input\_host\_header) | Host header value(s) for the rule. Set one of path\_pattern or host\_header. | `list(string)` | `null` | no |
| <a name="input_listener_arn"></a> [listener\_arn](#input\_listener\_arn) | ARN of the ALB listener (HTTP or HTTPS) | `string` | n/a | yes |
| <a name="input_path_pattern"></a> [path\_pattern](#input\_path\_pattern) | Path pattern for the rule (e.g. /api/*). Set one of path\_pattern or host\_header. | `string` | `null` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | Rule priority (1-50000, unique per listener) | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | `{}` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | ARN of the target group to forward to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_listener_rule_arn"></a> [listener\_rule\_arn](#output\_listener\_rule\_arn) | ARN of the listener rule |
| <a name="output_listener_rule_id"></a> [listener\_rule\_id](#output\_listener\_rule\_id) | ID of the listener rule |
<!-- END_TF_DOCS -->