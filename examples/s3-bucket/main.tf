provider "aws" {
  region = var.aws_region
}

module "bucket" {
  source = "../../s3"

  bucket_name = var.bucket_name
  tags        = var.tags
}
