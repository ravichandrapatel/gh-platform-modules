output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = var.create_certificate ? aws_acm_certificate.this[0].arn : null
}

output "certificate_domain_name" {
  description = "Domain name of the certificate"
  value       = var.create_certificate ? aws_acm_certificate.this[0].domain_name : null
}

output "certificate_status" {
  description = "Status of the certificate"
  value       = var.create_certificate ? aws_acm_certificate.this[0].status : null
}

output "domain_validation_options" {
  description = "Domain validation options for DNS validation"
  value       = var.create_certificate ? aws_acm_certificate.this[0].domain_validation_options : null
}

