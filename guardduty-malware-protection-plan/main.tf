# GuardDuty malware protection plan: S3 bucket object scanning with optional scan-result tagging.

resource "aws_guardduty_malware_protection_plan" "this" {
  role = var.role_arn

  protected_resource {
    s3_bucket {
      bucket_name     = var.bucket_name
      object_prefixes = length(var.object_prefixes) > 0 ? var.object_prefixes : null
    }
  }

  dynamic "actions" {
    for_each = var.enable_object_tagging ? [1] : []
    content {
      tagging {
        status = "ENABLED"
      }
    }
  }

  tags = var.tags
}
