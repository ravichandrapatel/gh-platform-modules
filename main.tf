# Secrets Manager Secret
resource "aws_secretsmanager_secret" "this" {
  name                    = var.secret_name
  description             = var.description
  recovery_window_in_days = var.recovery_window_in_days
  kms_key_id              = var.kms_key_id

  dynamic "replica" {
    for_each = var.replica_regions

    content {
      region     = replica.value.region
      kms_key_id = replica.value.kms_key_id
    }
  }

  tags = var.tags
}

# Read current secret value so we can preserve values updated in the console while applying key add/remove from Terraform.
# When preserve_existing_secret_values = false, we skip this so a missing current version does not cause errors.
data "aws_secretsmanager_secret_version" "current" {
  count     = var.preserve_existing_secret_values ? 1 : 0
  secret_id = aws_secretsmanager_secret.this.id
}

# Merge: keys from Terraform only (so add/remove keys in config updates the secret).
# Values: use existing from AWS if key exists (preserve console/rotation), else Terraform value.
# When preserve_existing_secret_values = false, we don't read AWS at all and use Terraform values directly.
locals {
  existing_secret = var.preserve_existing_secret_values && length(data.aws_secretsmanager_secret_version.current) > 0 ? try(jsondecode(data.aws_secretsmanager_secret_version.current[0].secret_string), {}) : {}

  merged_key_value = length(var.secret_key_value) > 0 ? (
    var.preserve_existing_secret_values ?
    { for k, v in var.secret_key_value : k => try(local.existing_secret[k], v) } :
    var.secret_key_value
  ) : {}
}

# Secret Version
resource "aws_secretsmanager_secret_version" "this" {
  count = var.secret_string != null || length(var.secret_key_value) > 0 || var.create_placeholder_version ? 1 : 0

  secret_id = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string != null ? var.secret_string : (
    length(var.secret_key_value) > 0 ? jsonencode(local.merged_key_value) : "{}"
  )

  # Temporarily commented so Terraform can push secret_key_value updates to already-deployed secrets.
  # Re-enable after apply so console/runtime value edits are not overwritten on every plan/apply.
  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Secret Rotation (only when a secret version exists)
resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.rotation_enabled && var.rotation_lambda_arn != "" && (var.secret_string != null || length(var.secret_key_value) > 0 || var.create_placeholder_version) ? 1 : 0

  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_days
  }

  depends_on = [aws_secretsmanager_secret_version.this]
}
