# SESv2 Configuration Set Module

Single SESv2 configuration set with optional tracking, reputation, sending, suppression, and VDM options.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_set_name"></a> [configuration\_set\_name](#input\_configuration\_set\_name) | SESv2 configuration set name | `string` | n/a | yes |
| <a name="input_reputation_options"></a> [reputation\_options](#input\_reputation\_options) | Optional reputation options | <pre>object({<br/>    last_fresh_start           = optional(string)<br/>    reputation_metrics_enabled = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_sending_options"></a> [sending\_options](#input\_sending\_options) | Optional sending options | <pre>object({<br/>    sending_enabled = bool<br/>  })</pre> | `null` | no |
| <a name="input_suppression_options"></a> [suppression\_options](#input\_suppression\_options) | Optional suppression options | <pre>object({<br/>    suppressed_reasons = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the SESv2 configuration set | `map(string)` | `{}` | no |
| <a name="input_tracking_options"></a> [tracking\_options](#input\_tracking\_options) | Optional tracking options | <pre>object({<br/>    custom_redirect_domain = string<br/>    https_policy           = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_vdm_options"></a> [vdm\_options](#input\_vdm\_options) | Optional VDM options | <pre>object({<br/>    dashboard_options = optional(object({<br/>      engagement_metrics = string<br/>    }))<br/>    guardian_options = optional(object({<br/>      optimized_shared_delivery = string<br/>    }))<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | SESv2 configuration set ARN |
| <a name="output_configuration_set_name"></a> [configuration\_set\_name](#output\_configuration\_set\_name) | SESv2 configuration set name |
<!-- END_TF_DOCS -->
