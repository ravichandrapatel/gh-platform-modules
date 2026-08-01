output "domain" {
  description = "Configured Cognito domain"
  value       = aws_cognito_user_pool_domain.this.domain
}

output "cloudfront_distribution" {
  description = "CloudFront distribution DNS name for custom domains"
  value       = aws_cognito_user_pool_domain.this.cloudfront_distribution
}

output "s3_bucket" {
  description = "S3 bucket where managed login assets are hosted"
  value       = aws_cognito_user_pool_domain.this.s3_bucket
}
