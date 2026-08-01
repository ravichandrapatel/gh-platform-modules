# Basic example: Lambda function with stub package and IAM role.

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
  source = "../../../iam"

  role_name   = "example-lambda-role"
  description = "Example Lambda execution role"

  trusted_entities = [
    {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
      conditions  = []
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = module.tags.tags
}

module "lambda" {
  source = "../.."

  function_name = "example-stub-function"
  role_arn      = module.role.role_arn
  runtime       = "python3.12"
  handler       = "handler.handler"

  environment_variables = {
    ENVIRONMENT = "NON-PROD"
  }

  tags = module.tags.tags
}

output "arn" {
  value = module.lambda.arn
}

output "name" {
  value = module.lambda.name
}
