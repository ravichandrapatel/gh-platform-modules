# SNS topic

Single Amazon SNS topic with optional subscriptions and an optional topic policy so **EventBridge** can publish deployment or operational events to the topic.

Use with [`eventbridge-rule`](../eventbridge-rule): set `allow_eventbridge_publish = true` on this module, then point the rule's SNS target at `module.sns_topic.arn`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_eventbridge_publish"></a> [allow\_eventbridge\_publish](#input\_allow\_eventbridge\_publish) | If true, attach a topic policy allowing events.amazonaws.com to sns:Publish from this account (for EventBridge → SNS targets). | `bool` | `false` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for SMS subscriptions (optional). | `string` | `null` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | KMS key ID or ARN for server-side encryption of topic contents. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the SNS topic. Exactly one of name or name\_prefix must be set. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with this prefix. Exactly one of name or name\_prefix must be set. | `string` | `null` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | Map of subscription key → protocol and endpoint (e.g. email, https, sqs, lambda). | <pre>map(object({<br/>    protocol = string<br/>    endpoint = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the SNS topic. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the SNS topic. |
| <a name="output_id"></a> [id](#output\_id) | ID of the SNS topic (same as name for a named topic). |
| <a name="output_name"></a> [name](#output\_name) | Name of the SNS topic. |
<!-- END_TF_DOCS -->
