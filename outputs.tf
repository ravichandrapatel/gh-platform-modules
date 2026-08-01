output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the ALB"
  value       = aws_lb.this.zone_id
}

output "target_group_arn" {
  description = "ARN of the default target group (backward compatible)"
  value       = aws_lb_target_group.this.arn
}

output "target_group_arns" {
  description = "Map of target group ARNs: 'default' = default TG, plus keys from additional_target_groups. Pass to ECS or other services."
  value       = local.target_group_arns
}

output "target_group_name" {
  description = "Name of the default target group"
  value       = aws_lb_target_group.this.name
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = var.acm_certificate_arn != "" ? aws_lb_listener.https[0].arn : null
}
