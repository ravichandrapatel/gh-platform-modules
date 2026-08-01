# SES Email Identity Module

Single SES email identity using SESv2 with optional DKIM signing attributes.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dkim_signing_attributes"></a> [dkim\_signing\_attributes](#input\_dkim\_signing\_attributes) | Optional DKIM signing attributes for BYODKIM | <pre>object({<br/>    domain_signing_private_key = optional(string)<br/>    domain_signing_selector    = optional(string)<br/>    next_signing_key_length    = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_email_identity"></a> [email\_identity](#input\_email\_identity) | SES email identity (email address or domain) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the SES email identity | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | SES email identity ARN |
| <a name="output_email_identity"></a> [email\_identity](#output\_email\_identity) | Configured SES email identity |
<!-- END_TF_DOCS -->
