# Cognito User Pool Module

Single Cognito user pool with dynamic schema and optional nested configuration blocks.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_recovery_setting"></a> [account\_recovery\_setting](#input\_account\_recovery\_setting) | Optional account recovery settings | <pre>object({<br/>    recovery_mechanisms = list(object({<br/>      name     = string<br/>      priority = number<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_admin_create_user_config"></a> [admin\_create\_user\_config](#input\_admin\_create\_user\_config) | Optional admin create user configuration | <pre>object({<br/>    allow_admin_create_user_only = optional(bool)<br/>    invite_message_template = optional(object({<br/>      email_message = optional(string)<br/>      email_subject = optional(string)<br/>      sms_message   = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_alias_attributes"></a> [alias\_attributes](#input\_alias\_attributes) | Alias attributes | `list(string)` | `[]` | no |
| <a name="input_auto_verified_attributes"></a> [auto\_verified\_attributes](#input\_auto\_verified\_attributes) | Auto-verified attributes | `list(string)` | `[]` | no |
| <a name="input_email_configuration"></a> [email\_configuration](#input\_email\_configuration) | Optional email configuration | <pre>object({<br/>    configuration_set      = optional(string)<br/>    email_sending_account  = optional(string)<br/>    from_email_address     = optional(string)<br/>    reply_to_email_address = optional(string)<br/>    source_arn             = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_lambda_config"></a> [lambda\_config](#input\_lambda\_config) | Optional lambda triggers for user pool | <pre>object({<br/>    create_auth_challenge          = optional(string)<br/>    custom_message                 = optional(string)<br/>    define_auth_challenge          = optional(string)<br/>    post_authentication            = optional(string)<br/>    post_confirmation              = optional(string)<br/>    pre_authentication             = optional(string)<br/>    pre_sign_up                    = optional(string)<br/>    pre_token_generation           = optional(string)<br/>    user_migration                 = optional(string)<br/>    verify_auth_challenge_response = optional(string)<br/>    kms_key_id                     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | MFA configuration: OFF, ON, OPTIONAL | `string` | `"OFF"` | no |
| <a name="input_name"></a> [name](#input\_name) | Cognito user pool name | `string` | n/a | yes |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | Optional password policy | <pre>object({<br/>    minimum_length                   = optional(number)<br/>    require_lowercase                = optional(bool)<br/>    require_numbers                  = optional(bool)<br/>    require_symbols                  = optional(bool)<br/>    require_uppercase                = optional(bool)<br/>    temporary_password_validity_days = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | Custom schema attributes | <pre>list(object({<br/>    name                     = string<br/>    attribute_data_type      = string<br/>    developer_only_attribute = optional(bool)<br/>    mutable                  = optional(bool)<br/>    required                 = optional(bool)<br/>    string_attribute_constraints = optional(object({<br/>      min_length = optional(string)<br/>      max_length = optional(string)<br/>    }))<br/>    number_attribute_constraints = optional(object({<br/>      min_value = optional(string)<br/>      max_value = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_sms_configuration"></a> [sms\_configuration](#input\_sms\_configuration) | Optional SMS configuration | <pre>object({<br/>    external_id    = optional(string)<br/>    sns_caller_arn = string<br/>    sns_region     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Cognito user pool | `map(string)` | `{}` | no |
| <a name="input_username_attributes"></a> [username\_attributes](#input\_username\_attributes) | Attributes supported as username | `list(string)` | `[]` | no |
| <a name="input_verification_message_template"></a> [verification\_message\_template](#input\_verification\_message\_template) | Optional verification message template | <pre>object({<br/>    default_email_option  = optional(string)<br/>    email_message         = optional(string)<br/>    email_message_by_link = optional(string)<br/>    email_subject         = optional(string)<br/>    email_subject_by_link = optional(string)<br/>    sms_message           = optional(string)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Cognito user pool ARN |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Cognito user pool endpoint |
| <a name="output_id"></a> [id](#output\_id) | Cognito user pool ID |
| <a name="output_name"></a> [name](#output\_name) | Cognito user pool name |
<!-- END_TF_DOCS -->
