output "arn" {
  description = "SES domain identity ARN"
  value       = aws_ses_domain_identity.this.arn
}

output "domain" {
  description = "SES domain identity domain"
  value       = aws_ses_domain_identity.this.domain
}

output "verification_token" {
  description = "TXT verification token for the SES domain identity"
  value       = aws_ses_domain_identity.this.verification_token
}

output "dkim_tokens" {
  description = "DKIM CNAME tokens (if DKIM is enabled)"
  value       = var.enable_dkim ? aws_ses_domain_dkim.this[0].dkim_tokens : []
}

output "mail_from_domain" {
  description = "MAIL FROM domain (if configured)"
  value       = var.mail_from != null ? aws_ses_domain_mail_from.this[0].mail_from_domain : null
}
