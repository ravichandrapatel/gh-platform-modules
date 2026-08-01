# Basic example: Step Functions state machine with stub Pass ASL.

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

  role_name   = "example-sfn-role"
  description = "Example Step Functions execution role"

  trusted_entities = [
    {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
      conditions  = []
    }
  ]

  tags = module.tags.tags
}

module "sfn" {
  source = "../.."

  name     = "example-stub-state-machine"
  role_arn = module.role.role_arn
  definition = jsonencode({
    StartAt = "Stub"
    States = {
      Stub = {
        Type = "Pass"
        End  = true
      }
    }
  })

  tags = module.tags.tags
}

output "arn" {
  value = module.sfn.arn
}

output "name" {
  value = module.sfn.name
}
