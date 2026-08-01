output "aws_account_id" {
  description = "AWS account ID that owns the distribution (for SourceArn-style policies)"
  value       = data.aws_caller_identity.current.account_id
}

output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.this.arn
}

output "distribution_domain_name" {
  description = "CloudFront distribution domain"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "distribution_hosted_zone_id" {
  description = "CloudFront hosted zone ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "oai_iam_arn" {
  description = "OAI IAM ARN"
  value       = var.create_oai ? aws_cloudfront_origin_access_identity.this[0].iam_arn : null
}

output "oai_path" {
  description = "OAI path"
  value       = var.create_oai ? aws_cloudfront_origin_access_identity.this[0].cloudfront_access_identity_path : null
}

output "oac_id" {
  description = "OAC ID"
  value       = var.create_oac ? aws_cloudfront_origin_access_control.this[0].id : null
}

output "vpc_origin_ids" {
  description = "Map of CloudFront VPC origin IDs by origin_id"
  value       = { for k, v in aws_cloudfront_vpc_origin.this : k => v.id }
}
