# Basic example: S3 bucket notification wiring (replace ARNs before apply).

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "notification" {
  source = "../.."

  bucket = "example-bucket-name"

  lambda_notifications = {
    import-trigger = {
      function_arn  = "arn:aws:lambda:us-east-1:123456789012:function:example"
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "rxdetect/clean/"
    }
  }
}
