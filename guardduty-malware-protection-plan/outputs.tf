output "plan_id" {
  description = "ID of the GuardDuty malware protection plan"
  value       = aws_guardduty_malware_protection_plan.this.id
}

output "plan_arn" {
  description = "ARN of the GuardDuty malware protection plan"
  value       = aws_guardduty_malware_protection_plan.this.arn
}

output "status" {
  description = "Status of the malware protection plan (e.g. ACTIVE, WARNINGS)"
  value       = aws_guardduty_malware_protection_plan.this.status
}

output "bucket_name" {
  description = "Protected S3 bucket name"
  value       = var.bucket_name
}

output "role_arn" {
  description = "IAM role ARN used by the plan"
  value       = var.role_arn
}
