variable "domain" {
  description = "Cognito user pool domain prefix or custom domain"
  type        = string
}

variable "user_pool_id" {
  description = "Cognito user pool ID"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for a custom domain (optional)"
  type        = string
  default     = null
}
