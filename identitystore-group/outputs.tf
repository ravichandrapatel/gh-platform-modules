# identitystore-group module - Outputs for use by account-assignment (principal_id).

output "group_id" {
  description = "Identity Store group ID (GUID). Use as principal_id in account-assignment when principal_type = 'GROUP'."
  value       = aws_identitystore_group.this.group_id
}

output "display_name" {
  description = "Display name of the group."
  value       = aws_identitystore_group.this.display_name
}

output "external_ids" {
  description = "External IDs of the group (if any)."
  value       = aws_identitystore_group.this.external_ids
}
