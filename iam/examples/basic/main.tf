# Basic example: IAM role with assume role policy and managed policy attachment.

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

module "role" {
  source = "../.."

  role_name   = "example-role"
  description = "Example IAM role"

  trusted_entities = [
    {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
      conditions  = []
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]

  tags = module.tags.tags
}

output "role_arn" {
  value = module.role.role_arn
}

output "role_name" {
  value = module.role.role_name
}
