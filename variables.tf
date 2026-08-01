# account-assignment module - Input variables for a single account assignment.

variable "instance_arn" {
  description = "ARN of the IAM Identity Center (SSO) instance."
  type        = string
}

variable "permission_set_arn" {
  description = "ARN of the permission set to assign."
  type        = string
}

variable "principal_type" {
  description = "Type of principal: GROUP or USER."
  type        = string
  validation {
    condition     = contains(["GROUP", "USER"], var.principal_type)
    error_message = "principal_type must be either 'GROUP' or 'USER'."
  }
}

variable "principal_id" {
  description = "When principal_type = 'GROUP': Identity Store group ID (GUID), e.g. module.identitystore_group.group_id. When 'USER': Identity Store user ID (GUID)."
  type        = string
}

variable "target_id" {
  description = "Target AWS account ID (12 digits)."
  type        = string
  validation {
    condition     = can(regex("^[0-9]{12}$", var.target_id))
    error_message = "target_id must be a 12-digit AWS account ID."
  }
}

variable "target_type" {
  description = "Target type (default AWS_ACCOUNT)."
  type        = string
  default     = "AWS_ACCOUNT"
}
