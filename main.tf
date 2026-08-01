# Cognito user pool domain: single domain binding for a user pool.

resource "aws_cognito_user_pool_domain" "this" {
  domain          = var.domain
  user_pool_id    = var.user_pool_id
  certificate_arn = var.certificate_arn
}
