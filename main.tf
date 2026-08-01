# SES domain identity: single domain identity with optional DKIM and MAIL FROM settings.

resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

# Optional DKIM for the domain identity.
resource "aws_ses_domain_dkim" "this" {
  count = var.enable_dkim ? 1 : 0

  domain = aws_ses_domain_identity.this.domain
}

# Optional custom MAIL FROM domain.
resource "aws_ses_domain_mail_from" "this" {
  count = var.mail_from != null ? 1 : 0

  domain                 = aws_ses_domain_identity.this.domain
  mail_from_domain       = var.mail_from.mail_from_domain
  behavior_on_mx_failure = try(var.mail_from.behavior_on_mx_failure, "UseDefaultValue")
}
