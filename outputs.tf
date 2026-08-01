output "listener_rule_arn" {
  description = "ARN of the listener rule"
  value       = aws_lb_listener_rule.this.arn
}

output "listener_rule_id" {
  description = "ID of the listener rule"
  value       = aws_lb_listener_rule.this.id
}
