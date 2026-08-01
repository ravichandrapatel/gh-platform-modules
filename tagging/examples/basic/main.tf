# Basic example: tagging module output. Use tags in caller and pass to resource modules.

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
  source = "../.."

  environment = "NON-PROD"
  project     = "ExampleApp"
  cost_center = "CC-123"
  owner       = "Platform"
  tier        = "frontend"
}

output "tags" {
  value     = module.tags.tags
  sensitive = false
}
