# Cognito user pool: single user pool with dynamic schema and optional nested settings.

resource "aws_cognito_user_pool" "this" {
  name                     = var.name
  username_attributes      = var.username_attributes
  alias_attributes         = var.alias_attributes
  auto_verified_attributes = var.auto_verified_attributes
  mfa_configuration        = var.mfa_configuration

  dynamic "password_policy" {
    for_each = var.password_policy != null ? [var.password_policy] : []
    content {
      minimum_length                   = try(password_policy.value.minimum_length, null)
      require_lowercase                = try(password_policy.value.require_lowercase, null)
      require_numbers                  = try(password_policy.value.require_numbers, null)
      require_symbols                  = try(password_policy.value.require_symbols, null)
      require_uppercase                = try(password_policy.value.require_uppercase, null)
      temporary_password_validity_days = try(password_policy.value.temporary_password_validity_days, null)
    }
  }

  dynamic "schema" {
    for_each = var.schemas
    content {
      attribute_data_type      = schema.value.attribute_data_type
      developer_only_attribute = try(schema.value.developer_only_attribute, null)
      mutable                  = try(schema.value.mutable, null)
      name                     = schema.value.name
      required                 = try(schema.value.required, null)

      dynamic "string_attribute_constraints" {
        for_each = try(schema.value.string_attribute_constraints, null) != null ? [schema.value.string_attribute_constraints] : []
        content {
          min_length = try(string_attribute_constraints.value.min_length, null)
          max_length = try(string_attribute_constraints.value.max_length, null)
        }
      }

      dynamic "number_attribute_constraints" {
        for_each = try(schema.value.number_attribute_constraints, null) != null ? [schema.value.number_attribute_constraints] : []
        content {
          min_value = try(number_attribute_constraints.value.min_value, null)
          max_value = try(number_attribute_constraints.value.max_value, null)
        }
      }
    }
  }

  dynamic "admin_create_user_config" {
    for_each = var.admin_create_user_config != null ? [var.admin_create_user_config] : []
    content {
      allow_admin_create_user_only = try(admin_create_user_config.value.allow_admin_create_user_only, null)

      dynamic "invite_message_template" {
        for_each = try(admin_create_user_config.value.invite_message_template, null) != null ? [admin_create_user_config.value.invite_message_template] : []
        content {
          email_message = try(invite_message_template.value.email_message, null)
          email_subject = try(invite_message_template.value.email_subject, null)
          sms_message   = try(invite_message_template.value.sms_message, null)
        }
      }
    }
  }

  dynamic "verification_message_template" {
    for_each = var.verification_message_template != null ? [var.verification_message_template] : []
    content {
      default_email_option  = try(verification_message_template.value.default_email_option, null)
      email_message         = try(verification_message_template.value.email_message, null)
      email_message_by_link = try(verification_message_template.value.email_message_by_link, null)
      email_subject         = try(verification_message_template.value.email_subject, null)
      email_subject_by_link = try(verification_message_template.value.email_subject_by_link, null)
      sms_message           = try(verification_message_template.value.sms_message, null)
    }
  }

  dynamic "account_recovery_setting" {
    for_each = var.account_recovery_setting != null ? [var.account_recovery_setting] : []
    content {
      dynamic "recovery_mechanism" {
        for_each = account_recovery_setting.value.recovery_mechanisms
        content {
          name     = recovery_mechanism.value.name
          priority = recovery_mechanism.value.priority
        }
      }
    }
  }

  dynamic "email_configuration" {
    for_each = var.email_configuration != null ? [var.email_configuration] : []
    content {
      configuration_set      = try(email_configuration.value.configuration_set, null)
      email_sending_account  = try(email_configuration.value.email_sending_account, null)
      from_email_address     = try(email_configuration.value.from_email_address, null)
      reply_to_email_address = try(email_configuration.value.reply_to_email_address, null)
      source_arn             = try(email_configuration.value.source_arn, null)
    }
  }

  dynamic "sms_configuration" {
    for_each = var.sms_configuration != null ? [var.sms_configuration] : []
    content {
      external_id    = try(sms_configuration.value.external_id, null)
      sns_caller_arn = sms_configuration.value.sns_caller_arn
      sns_region     = try(sms_configuration.value.sns_region, null)
    }
  }

  dynamic "lambda_config" {
    for_each = var.lambda_config != null ? [var.lambda_config] : []
    content {
      create_auth_challenge          = try(lambda_config.value.create_auth_challenge, null)
      custom_message                 = try(lambda_config.value.custom_message, null)
      define_auth_challenge          = try(lambda_config.value.define_auth_challenge, null)
      post_authentication            = try(lambda_config.value.post_authentication, null)
      post_confirmation              = try(lambda_config.value.post_confirmation, null)
      pre_authentication             = try(lambda_config.value.pre_authentication, null)
      pre_sign_up                    = try(lambda_config.value.pre_sign_up, null)
      pre_token_generation           = try(lambda_config.value.pre_token_generation, null)
      user_migration                 = try(lambda_config.value.user_migration, null)
      verify_auth_challenge_response = try(lambda_config.value.verify_auth_challenge_response, null)
      kms_key_id                     = try(lambda_config.value.kms_key_id, null)
    }
  }

  tags = var.tags
}
