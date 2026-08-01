variable "name" {
  description = "The name of the account."
  type        = string
}

variable "email" {
  description = "The email address of the account."
  type        = string
}

variable "parent_id" {
  description = "The parent ID of the account."
  type        = string
  default     = null
}

variable "role_name" {
  description = "The name of the role that is created in the account."
  type        = string
  default     = "OrganizationAccountAccessRole"
}

variable "iam_user_access_to_billing" {
  description = "If set to ALLOW, the new account enables IAM users to access account billing information if they have the required permissions."
  type        = string
  default     = "ALLOW"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
