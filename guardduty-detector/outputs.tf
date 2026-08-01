output "detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.this.id
}

output "detector_arn" {
  description = "ARN of the GuardDuty detector"
  value       = aws_guardduty_detector.this.arn
}

output "account_id" {
  description = "AWS account ID associated with the detector"
  value       = aws_guardduty_detector.this.account_id
}
