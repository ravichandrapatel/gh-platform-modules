output "id" {
  description = "The ID of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.this.id
}

output "arn" {
  description = "The ARN of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.this.arn
}

output "dns_name" {
  description = "The DNS name of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.this.dns_name
}
