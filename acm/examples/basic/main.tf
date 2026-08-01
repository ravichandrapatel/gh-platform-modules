# Basic example: ACM certificate (DNS validation). Replace domain with one you own.

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

module "cert" {
  source = "../.."

  domain_name               = "example.com"
  subject_alternative_names = ["www.example.com"]
  validation_method         = "DNS"
  create_certificate        = true

  tags = module.tags.tags
}

output "certificate_arn" {
  value = module.cert.certificate_arn
}
