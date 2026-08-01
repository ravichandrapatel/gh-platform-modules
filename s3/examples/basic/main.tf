# Basic example: S3 bucket with versioning and encryption.

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

module "bucket" {
  source = "../.."

  bucket_name             = "example-bucket-unique-12345"
  enable_versioning       = true
  enable_encryption       = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = module.tags.tags
}

output "bucket_id" {
  value = module.bucket.bucket_id
}

output "bucket_arn" {
  value = module.bucket.bucket_arn
}
