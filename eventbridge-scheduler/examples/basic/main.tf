# Basic example: EventBridge Scheduler (definition only — wire real target ARNs before apply).

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Placeholder — replace with real state machine / role ARNs before apply.
module "schedule" {
  source = "../.."

  name                = "example-hourly-schedule"
  schedule_expression = "rate(1 hour)"
  target_arn          = "arn:aws:states:us-east-1:123456789012:stateMachine:example"
  role_arn            = "arn:aws:iam::123456789012:role/example-scheduler-role"
}
