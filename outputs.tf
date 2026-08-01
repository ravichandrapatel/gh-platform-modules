output "arn" {
  description = "SES email identity ARN"
  value       = aws_sesv2_email_identity.this.arn
}

output "email_identity" {
  description = "Configured SES email identity"
  value       = aws_sesv2_email_identity.this.email_identity
}
