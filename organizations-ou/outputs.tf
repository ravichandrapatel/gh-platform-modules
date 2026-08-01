output "arn" {
  description = "ARN of the organizational unit"
  value       = aws_organizations_organizational_unit.this.arn
}

output "id" {
  description = "Identifier of the organizational unit"
  value       = aws_organizations_organizational_unit.this.id
}
