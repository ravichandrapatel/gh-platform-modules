provider "aws" {
  region = var.aws_region
}

module "bucket" {
  source = "../../modules/s3-bucket"

  bucket_name   = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}
