# Basic example: Cognito user pool domain.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "cognito_user_pool_domain" {
  source = "../.."

  domain       = "example-auth-domain"
  user_pool_id = "us-east-1_example"
}

output "domain" {
  value = module.cognito_user_pool_domain.domain
}
