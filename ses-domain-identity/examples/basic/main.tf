# Basic example: SES domain identity with DKIM and optional MAIL FROM.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ses_domain_identity" {
  source = "../.."

  domain      = "example.com"
  enable_dkim = true
  mail_from = {
    mail_from_domain       = "mail.example.com"
    behavior_on_mx_failure = "UseDefaultValue"
  }
}

output "verification_token" {
  value = module.ses_domain_identity.verification_token
}

output "dkim_tokens" {
  value = module.ses_domain_identity.dkim_tokens
}
