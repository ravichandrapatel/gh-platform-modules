output "id" {
  description = "Cognito user pool ID"
  value       = aws_cognito_user_pool.this.id
}

output "arn" {
  description = "Cognito user pool ARN"
  value       = aws_cognito_user_pool.this.arn
}

output "name" {
  description = "Cognito user pool name"
  value       = aws_cognito_user_pool.this.name
}

output "endpoint" {
  description = "Cognito user pool endpoint"
  value       = aws_cognito_user_pool.this.endpoint
}
