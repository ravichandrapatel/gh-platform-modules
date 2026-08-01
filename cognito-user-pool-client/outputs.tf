output "id" {
  description = "Cognito user pool client ID"
  value       = aws_cognito_user_pool_client.this.id
}

output "client_id" {
  description = "Cognito user pool client ID"
  value       = aws_cognito_user_pool_client.this.id
}

output "client_secret" {
  description = "Cognito user pool client secret (if generated)"
  value       = aws_cognito_user_pool_client.this.client_secret
  sensitive   = true
}

output "name" {
  description = "Cognito user pool client name"
  value       = var.name
}
