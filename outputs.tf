output "arn" {
  description = "The ARN assigned by AWS for this SAML provider."
  value       = aws_iam_saml_provider.this.arn
}

output "name" {
  description = "The name of the SAML provider."
  value       = aws_iam_saml_provider.this.name
}

output "valid_until" {
  description = "The expiration date and time for the SAML provider."
  value       = aws_iam_saml_provider.this.valid_until
}
