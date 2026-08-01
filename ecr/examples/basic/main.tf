# Basic example: ECR repository with scan on push.

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

module "ecr" {
  source = "../.."

  repository_name                 = "example-app"
  scan_on_push                    = true
  image_tag_mutability            = "MUTABLE"
  enable_default_lifecycle_policy = true

  tags = module.tags.tags
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "repository_arn" {
  value = module.ecr.repository_arn
}
