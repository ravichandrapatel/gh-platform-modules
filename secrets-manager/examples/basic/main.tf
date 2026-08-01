# Basic example: Secrets Manager secret with a string value.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "tags" {
  source      = "../../../tagging"
  environment = "NON-PROD"
  project     = "ExampleApp"
}

module "secret" {
  source = "../.."

  secret_name             = "example/secret"
  description             = "Example secret"
  secret_string           = jsonencode({ key = "value" })
  recovery_window_in_days = 7

  tags = module.tags.tags
}

output "secret_arn" {
  value = module.secret.secret_arn
}

output "secret_id" {
  value = module.secret.secret_id
}
