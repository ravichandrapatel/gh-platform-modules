# Basic example: Cognito user pool.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "cognito_user_pool" {
  source = "../.."

  name                     = "example-user-pool"
  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF"
  password_policy = {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
}

output "user_pool_id" {
  value = module.cognito_user_pool.id
}
