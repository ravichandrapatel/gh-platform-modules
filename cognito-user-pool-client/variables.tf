variable "name" {
  description = "Cognito user pool client name"
  type        = string
}

variable "user_pool_id" {
  description = "Cognito user pool ID"
  type        = string
}

variable "generate_secret" {
  description = "Generate a client secret"
  type        = bool
  default     = false
}

variable "refresh_token_validity" {
  description = "Refresh token validity in days"
  type        = number
  default     = 30
}

variable "access_token_validity" {
  description = "Access token validity in minutes"
  type        = number
  default     = 60
}

variable "id_token_validity" {
  description = "ID token validity in minutes"
  type        = number
  default     = 60
}

variable "enable_token_revocation" {
  description = "Enable token revocation"
  type        = bool
  default     = true
}

variable "prevent_user_existence_errors" {
  description = "Prevent user existence errors mode"
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "LEGACY"], var.prevent_user_existence_errors)
    error_message = "prevent_user_existence_errors must be ENABLED or LEGACY."
  }
}

variable "explicit_auth_flows" {
  description = "Explicit authentication flows"
  type        = list(string)
  default     = []
}

variable "allowed_oauth_flows" {
  description = "Allowed OAuth flows"
  type        = list(string)
  default     = []
}

variable "allowed_oauth_flows_user_pool_client" {
  description = "Whether OAuth flows are enabled for the app client"
  type        = bool
  default     = false
}

variable "allowed_oauth_scopes" {
  description = "Allowed OAuth scopes"
  type        = list(string)
  default     = []
}

variable "callback_urls" {
  description = "OAuth callback URLs"
  type        = list(string)
  default     = []
}

variable "logout_urls" {
  description = "OAuth logout URLs"
  type        = list(string)
  default     = []
}

variable "supported_identity_providers" {
  description = "Supported identity providers"
  type        = list(string)
  default     = ["COGNITO"]
}

variable "read_attributes" {
  description = "Readable attributes"
  type        = list(string)
  default     = []
}

variable "write_attributes" {
  description = "Writable attributes"
  type        = list(string)
  default     = []
}
