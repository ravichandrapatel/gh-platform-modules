resource "random_id" "suffix" {
  byte_length = 4
}

module "log_group" {
  source = "../../../../cloudwatch-logs"

  name              = "/floci/test/${random_id.suffix.hex}"
  retention_in_days = 1
  kms_key_id        = null
  skip_destroy      = false
  log_group_class   = "STANDARD"
  tags = {
    Environment = "test"
    Project     = "floci"
    ManagedBy   = "opentofu"
  }
}

output "log_group_name" {
  value = module.log_group.name
}
