output "zone_id" {
  description = "The Hosted Zone ID used for the records"
  value       = data.aws_route53_zone.this.zone_id
}

output "zone_name" {
  description = "The name of the Hosted Zone"
  value       = data.aws_route53_zone.this.name
}

output "record_fqdns" {
  description = "Map of record keys to FQDNs for the created records"
  value       = { for k, v in aws_route53_record.this : k => v.fqdn }
}
