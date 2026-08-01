output "arn" {
  description = "ARN of the organization"
  value       = aws_organizations_organization.this.arn
}

output "id" {
  description = "Identifier of the organization"
  value       = aws_organizations_organization.this.id
}

output "master_account_arn" {
  description = "ARN of the master account"
  value       = aws_organizations_organization.this.master_account_arn
}

output "master_account_id" {
  description = "Identifier of the master account"
  value       = aws_organizations_organization.this.master_account_id
}

output "roots" {
  description = "List of organization roots"
  value       = aws_organizations_organization.this.roots
}
