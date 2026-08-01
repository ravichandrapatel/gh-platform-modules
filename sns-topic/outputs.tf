output "arn" {
  description = "ARN of the SNS topic."
  value       = aws_sns_topic.this.arn
}

output "name" {
  description = "Name of the SNS topic."
  value       = aws_sns_topic.this.name
}

output "id" {
  description = "ID of the SNS topic (same as name for a named topic)."
  value       = aws_sns_topic.this.id
}
