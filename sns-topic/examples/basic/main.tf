# Basic example: SNS topic with EventBridge publish policy (no subscriptions).

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "topic" {
  source = "../.."

  name                      = "example-ops-alerts"
  allow_eventbridge_publish = true
  tags = {
    Environment = "NON-PROD"
    Project     = "Example"
    ManagedBy   = "terraform"
  }
}

output "topic_arn" {
  value = module.topic.arn
}
