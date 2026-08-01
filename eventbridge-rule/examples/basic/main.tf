# Example: ECS deployment failure events → SNS (replace cluster_arn with your cluster).

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  # Replace with dependency.cluster.outputs.cluster_arn in Terragrunt.
  cluster_arn = "arn:aws:ecs:us-east-1:123456789012:cluster/example-cluster"
}

module "topic" {
  source = "../../../sns-topic"

  name                      = "example-ecs-deployment-alerts"
  allow_eventbridge_publish = true
  tags = {
    Environment = "NON-PROD"
    ManagedBy   = "terraform"
  }
}

module "ecs_deployment_failures" {
  source = "../.."

  name        = "example-ecs-deployment-failures"
  description = "Notify when ECS reports a failed service deployment for the cluster"
  event_pattern = jsonencode({
    source      = ["aws.ecs"]
    detail-type = ["ECS Service Action"]
    detail = {
      eventName  = ["SERVICE_DEPLOYMENT_FAILED"]
      clusterArn = [local.cluster_arn]
    }
  })
  target_sns_topic_arn = module.topic.arn
  tags = {
    Environment = "NON-PROD"
    ManagedBy   = "terraform"
  }
}

output "rule_arn" {
  value = module.ecs_deployment_failures.rule_arn
}

output "topic_arn" {
  value = module.topic.arn
}
