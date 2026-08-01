# Basic example: GuardDuty detector for an AWS account.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "guardduty" {
  source = "../.."

  enable = true
}

output "detector_id" {
  value = module.guardduty.detector_id
}
