resource "random_id" "suffix" {
  byte_length = 4
}

module "secret" {
  source = "../../../../secrets-manager"

  secret_name             = "floci/secret-${random_id.suffix.hex}"
  description             = "Floci integration test secret"
  secret_string           = jsonencode({ key = "value" })
  recovery_window_in_days = 0

  tags = {
    Environment = "test"
    Project     = "floci"
    ManagedBy   = "opentofu"
  }
}

output "secret_arn" {
  value = module.secret.secret_arn
}
