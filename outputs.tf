output "certificate_arn" {
  description = "ARN of the validated ACM certificate (ISSUED)."
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "validation_record_fqdns" {
  description = "FQDNs of the Route 53 validation records created."
  value       = [for r in aws_route53_record.validation : r.fqdn]
}
