# Cognito user pool client: single app client with optional OAuth and token validity settings.

resource "aws_cognito_user_pool_client" "this" {
  name         = var.name
  user_pool_id = var.user_pool_id

  generate_secret                      = var.generate_secret
  refresh_token_validity               = var.refresh_token_validity
  access_token_validity                = var.access_token_validity
  id_token_validity                    = var.id_token_validity
  enable_token_revocation              = var.enable_token_revocation
  prevent_user_existence_errors        = var.prevent_user_existence_errors
  explicit_auth_flows                  = var.explicit_auth_flows
  allowed_oauth_flows                  = var.allowed_oauth_flows
  allowed_oauth_flows_user_pool_client = var.allowed_oauth_flows_user_pool_client
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  supported_identity_providers         = var.supported_identity_providers
  read_attributes                      = var.read_attributes
  write_attributes                     = var.write_attributes
}
