# permission-set module - Outputs for the single permission set (ARN, ID, name).

output "permission_set_arn" {
  description = "ARN of the permission set."
  value       = aws_ssoadmin_permission_set.this.arn
}

output "permission_set_id" {
  description = "ID of the permission set."
  value       = aws_ssoadmin_permission_set.this.id
}

output "name" {
  description = "Name of the permission set."
  value       = aws_ssoadmin_permission_set.this.name
}
