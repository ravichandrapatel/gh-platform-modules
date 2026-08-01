# Basic example: Cognito user pool client.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "cognito_user_pool_client" {
  source = "../.."

  name         = "example-client"
  user_pool_id = "us-east-1_example"

  generate_secret = false
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
}

output "client_id" {
  value = module.cognito_user_pool_client.client_id
}
