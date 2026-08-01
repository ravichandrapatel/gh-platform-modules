output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways"
  value       = aws_nat_gateway.this[*].id
}

output "nat_gateway_public_ips" {
  description = "Public IPs of NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

output "public_route_table_id" {
  description = "ID of the legacy single public route table; null when using split public routing (see public_route_table_ids)."
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
}

output "public_route_table_ids" {
  description = "All public-facing route table IDs (one entry in legacy mode; IGW and/or NAT tables in split mode)."
  value       = local.public_route_table_ids_for_gateway
}

output "private_route_table_ids" {
  description = "IDs of private route tables"
  value       = aws_route_table.private[*].id
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = length(aws_vpn_gateway.this) > 0 ? aws_vpn_gateway.this[0].id : null
}

output "vpc_endpoint_ids" {
  description = "IDs of VPC endpoints"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.id }
}

output "vpc_endpoint_dns_entries" {
  description = "DNS entries of VPC endpoints"
  value       = { for k, v in aws_vpc_endpoint.this : k => v.dns_entry }
}

output "flow_logs_log_group_name" {
  description = "Name of the CloudWatch log group for flow logs"
  value       = length(aws_cloudwatch_log_group.flow_logs) > 0 ? aws_cloudwatch_log_group.flow_logs[0].name : null
}
