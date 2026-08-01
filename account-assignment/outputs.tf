# account-assignment module - Outputs for the single account assignment.

output "assignment_id" {
  description = "Composite ID of the account assignment."
  value       = aws_ssoadmin_account_assignment.this.id
}

output "principal_id" {
  description = "Principal ID (Identity Store group or user)."
  value       = aws_ssoadmin_account_assignment.this.principal_id
}

output "principal_type" {
  description = "Principal type (GROUP or USER)."
  value       = aws_ssoadmin_account_assignment.this.principal_type
}

output "target_id" {
  description = "Target account ID."
  value       = aws_ssoadmin_account_assignment.this.target_id
}

output "permission_set_arn" {
  description = "Permission set ARN that was assigned."
  value       = aws_ssoadmin_account_assignment.this.permission_set_arn
}
