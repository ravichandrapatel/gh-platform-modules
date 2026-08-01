output "fqdns" {
  description = "Map of record keys to FQDNs."
  value       = { for k, v in aws_route53_record.this : k => v.fqdn }
}

output "names" {
  description = "Map of record keys to expanded record names."
  value       = { for k, v in aws_route53_record.this : k => v.name }
}

output "types" {
  description = "Map of record keys to DNS types."
  value       = { for k, v in aws_route53_record.this : k => v.type }
}
