# permission-set module - Input variables for a single permission set and dynamic policy attachments.

variable "instance_arn" {
  description = "ARN of the IAM Identity Center (SSO) instance."
  type        = string
}

variable "name" {
  description = "Name of the permission set. Typically use the same name as the Identity Center group (e.g. 'Developers')."
  type        = string
}

variable "description" {
  description = "Description of the permission set."
  type        = string
  default     = null
}

variable "session_duration" {
  description = "Session duration (e.g. PT1H, PT8H, PT12H)."
  type        = string
  default     = "PT1H"
}

variable "relay_state" {
  description = "URL for federation redirect (optional)."
  type        = string
  default     = null
}

variable "managed_policy_arns" {
  description = "List of AWS managed policy ARNs to attach (dynamic attachment)."
  type        = list(string)
  default     = []
}

variable "inline_policy" {
  description = "JSON policy document for inline policy (at most one per permission set in AWS)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the permission set."
  type        = map(string)
  default     = {}
}
