resource "random_id" "suffix" {
  byte_length = 4
}

module "bucket" {
  source = "../../../../s3"

  bucket_name             = "floci-s3-${random_id.suffix.hex}"
  enable_versioning       = true
  enable_encryption       = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    Environment = "test"
    Project     = "floci"
    ManagedBy   = "opentofu"
  }
}

output "bucket_id" {
  value = module.bucket.bucket_id
}
