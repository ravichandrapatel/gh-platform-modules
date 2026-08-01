output "zone_id" {
  description = "Hosted zone ID (use in aws_route53_record.zone_id)."
  value       = aws_route53_zone.this.zone_id
}

output "name" {
  description = "Hosted zone name."
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "Delegate NS records to these for public zones; empty for private-only usage."
  value       = aws_route53_zone.this.name_servers
}

output "arn" {
  description = "Route 53 hosted zone ARN."
  value       = aws_route53_zone.this.arn
}
