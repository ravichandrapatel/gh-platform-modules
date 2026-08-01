# SES email identity: single email identity using SESv2 with optional DKIM signing attributes.

resource "aws_sesv2_email_identity" "this" {
  email_identity = var.email_identity

  dynamic "dkim_signing_attributes" {
    for_each = var.dkim_signing_attributes != null ? [var.dkim_signing_attributes] : []
    content {
      domain_signing_private_key = try(dkim_signing_attributes.value.domain_signing_private_key, null)
      domain_signing_selector    = try(dkim_signing_attributes.value.domain_signing_selector, null)
      next_signing_key_length    = try(dkim_signing_attributes.value.next_signing_key_length, null)
    }
  }

  tags = var.tags
}
