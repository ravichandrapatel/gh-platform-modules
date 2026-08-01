output "arn" {
  description = "ARN of the schedule"
  value       = aws_scheduler_schedule.this.arn
}

output "id" {
  description = "ID of the schedule"
  value       = aws_scheduler_schedule.this.id
}

output "name" {
  description = "Name of the schedule"
  value       = aws_scheduler_schedule.this.name
}
