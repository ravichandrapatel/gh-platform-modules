output "deployment_circuit_breaker_enabled" {
  description = "Whether the ECS deployment circuit breaker is enabled on this service."
  value       = var.enable_deployment_circuit_breaker
}

output "deployment_circuit_breaker_rollback" {
  description = "Whether automatic rollback is enabled when the deployment circuit breaker trips (false if the breaker is disabled)."
  value       = var.enable_deployment_circuit_breaker && var.deployment_circuit_breaker_rollback
}

output "deployment_failure_event_rule_arn" {
  description = "EventBridge rule ARN for ECS deployment failure → SNS (null if deployment_failure_sns_topic_arn is not set)."
  value       = try(aws_cloudwatch_event_rule.deployment_failure[0].arn, null)
}

output "deployment_failure_sns_topic_arn" {
  description = "SNS topic ARN used for deployment failure notifications (echo of input when configured)."
  value       = local.deployment_failure_notifications ? var.deployment_failure_sns_topic_arn : null
}

output "service_id" {
  description = "ECS service ID"
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "Task definition ARN (service uses this; revisions not pinned in config)"
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Task definition family"
  value       = aws_ecs_task_definition.this.family
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.this.name
}

output "autoscaling_target_resource_id" {
  description = "Application Auto Scaling resource_id (service/clusterName/serviceName) when enable_autoscaling is true."
  value       = try(aws_appautoscaling_target.ecs[0].resource_id, null)
}
