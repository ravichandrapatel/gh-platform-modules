variable "name" {
  description = "Cognito user pool name"
  type        = string
}

variable "username_attributes" {
  description = "Attributes supported as username"
  type        = list(string)
  default     = []
}

variable "alias_attributes" {
  description = "Alias attributes"
  type        = list(string)
  default     = []
}

variable "auto_verified_attributes" {
  description = "Auto-verified attributes"
  type        = list(string)
  default     = []
}

variable "mfa_configuration" {
  description = "MFA configuration: OFF, ON, OPTIONAL"
  type        = string
  default     = "OFF"

  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.mfa_configuration)
    error_message = "mfa_configuration must be OFF, ON, or OPTIONAL."
  }
}

variable "password_policy" {
  description = "Optional password policy"
  type = object({
    minimum_length                   = optional(number)
    require_lowercase                = optional(bool)
    require_numbers                  = optional(bool)
    require_symbols                  = optional(bool)
    require_uppercase                = optional(bool)
    temporary_password_validity_days = optional(number)
  })
  default = null
}

variable "schemas" {
  description = "Custom schema attributes"
  type = list(object({
    name                     = string
    attribute_data_type      = string
    developer_only_attribute = optional(bool)
    mutable                  = optional(bool)
    required                 = optional(bool)
    string_attribute_constraints = optional(object({
      min_length = optional(string)
      max_length = optional(string)
    }))
    number_attribute_constraints = optional(object({
      min_value = optional(string)
      max_value = optional(string)
    }))
  }))
  default = []
}

variable "admin_create_user_config" {
  description = "Optional admin create user configuration"
  type = object({
    allow_admin_create_user_only = optional(bool)
    invite_message_template = optional(object({
      email_message = optional(string)
      email_subject = optional(string)
      sms_message   = optional(string)
    }))
  })
  default = null
}

variable "verification_message_template" {
  description = "Optional verification message template"
  type = object({
    default_email_option  = optional(string)
    email_message         = optional(string)
    email_message_by_link = optional(string)
    email_subject         = optional(string)
    email_subject_by_link = optional(string)
    sms_message           = optional(string)
  })
  default = null
}

variable "account_recovery_setting" {
  description = "Optional account recovery settings"
  type = object({
    recovery_mechanisms = list(object({
      name     = string
      priority = number
    }))
  })
  default = null
}

variable "email_configuration" {
  description = "Optional email configuration"
  type = object({
    configuration_set      = optional(string)
    email_sending_account  = optional(string)
    from_email_address     = optional(string)
    reply_to_email_address = optional(string)
    source_arn             = optional(string)
  })
  default = null
}

variable "sms_configuration" {
  description = "Optional SMS configuration"
  type = object({
    external_id    = optional(string)
    sns_caller_arn = string
    sns_region     = optional(string)
  })
  default = null
}

variable "lambda_config" {
  description = "Optional lambda triggers for user pool"
  type = object({
    create_auth_challenge          = optional(string)
    custom_message                 = optional(string)
    define_auth_challenge          = optional(string)
    post_authentication            = optional(string)
    post_confirmation              = optional(string)
    pre_authentication             = optional(string)
    pre_sign_up                    = optional(string)
    pre_token_generation           = optional(string)
    user_migration                 = optional(string)
    verify_auth_challenge_response = optional(string)
    kms_key_id                     = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the Cognito user pool"
  type        = map(string)
  default     = {}
}
