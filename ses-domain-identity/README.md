# SES Domain Identity Module

Single SES domain identity with optional DKIM and custom MAIL FROM settings.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | SES domain identity (e.g. example.com) | `string` | n/a | yes |
| <a name="input_enable_dkim"></a> [enable\_dkim](#input\_enable\_dkim) | Enable SES DKIM for the domain | `bool` | `true` | no |
| <a name="input_mail_from"></a> [mail\_from](#input\_mail\_from) | Optional custom MAIL FROM settings | <pre>object({<br/>    mail_from_domain       = string<br/>    behavior_on_mx_failure = optional(string, "UseDefaultValue")<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply where supported | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | SES domain identity ARN |
| <a name="output_dkim_tokens"></a> [dkim\_tokens](#output\_dkim\_tokens) | DKIM CNAME tokens (if DKIM is enabled) |
| <a name="output_domain"></a> [domain](#output\_domain) | SES domain identity domain |
| <a name="output_mail_from_domain"></a> [mail\_from\_domain](#output\_mail\_from\_domain) | MAIL FROM domain (if configured) |
| <a name="output_verification_token"></a> [verification\_token](#output\_verification\_token) | TXT verification token for the SES domain identity |
<!-- END_TF_DOCS -->
