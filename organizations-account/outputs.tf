output "arn" {
  description = "ARN of the account"
  value       = aws_organizations_account.this.arn
}

output "id" {
  description = "Identifier of the account"
  value       = aws_organizations_account.this.id
}
