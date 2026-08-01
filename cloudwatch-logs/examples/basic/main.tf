# Basic example: CloudWatch Log Group with all values set.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "log_group" {
  source = "../.."

  name              = "/example/app/my-service"
  retention_in_days = 30
  kms_key_id        = null
  skip_destroy      = false
  log_group_class   = "STANDARD"
  tags = {
    Environment = "NON-PROD"
    Project     = "ExampleApp"
    ManagedBy   = "terraform"
  }
}

output "log_group_name" {
  value = module.log_group.name
}

output "log_group_arn" {
  value = module.log_group.arn
}
