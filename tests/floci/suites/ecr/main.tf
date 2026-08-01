resource "random_id" "suffix" {
  byte_length = 4
}

module "ecr" {
  source = "../../../../ecr"

  repository_name                 = "floci-ecr-${random_id.suffix.hex}"
  scan_on_push                    = true
  image_tag_mutability            = "MUTABLE"
  enable_default_lifecycle_policy = true

  tags = {
    Environment = "test"
    Project     = "floci"
    ManagedBy   = "opentofu"
  }
}

output "repository_url" {
  value = module.ecr.repository_url
}
