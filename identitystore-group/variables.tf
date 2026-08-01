# identitystore-group module - Input variables for a single Identity Store group.

variable "identity_store_id" {
  description = "Identity Store ID (from the IAM Identity Center instance). Use e.g. tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]."
  type        = string
}

variable "display_name" {
  description = "Display name of the group. Typically use the same name as the permission set (e.g. 'Developers')."
  type        = string
}

variable "description" {
  description = "Description of the group."
  type        = string
  default     = null
}
