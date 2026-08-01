# Basic example: SES email identity.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ses_email_identity" {
  source = "../.."

  email_identity = "noreply@example.com"
}

output "identity_arn" {
  value = module.ses_email_identity.arn
}
