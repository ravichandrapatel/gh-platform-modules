variable "name" {
  description = "Name of the log group. Either name or name_prefix must be set (not both)."
  type        = string
  default     = null

  validation {
    condition     = (var.name != null && var.name_prefix == null) || (var.name == null && var.name_prefix != null)
    error_message = "Exactly one of name or name_prefix must be set."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with this prefix. Either name or name_prefix must be set."
  type        = string
  default     = null
}

variable "retention_in_days" {
  description = "Number of days to retain log events. Allowed values: 0 (never expire), 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653. Omit or set to null for no expiration."
  type        = number
  default     = null

  validation {
    condition = var.retention_in_days == null || contains([
      0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731,
      1096, 1827, 2192, 2557, 2922, 3288, 3653
    ], var.retention_in_days)
    error_message = "retention_in_days must be one of: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, or null."
  }
}

variable "kms_key_id" {
  description = "ARN or ID of the KMS key to use for encrypting log data. Omit for default encryption."
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "If true, Terraform will remove the log group from state on destroy instead of deleting it in AWS."
  type        = bool
  default     = false
}

variable "log_group_class" {
  description = "Log class: STANDARD (default) or INFREQUENT_ACCESS. Cannot be changed after creation."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "INFREQUENT_ACCESS"], var.log_group_class)
    error_message = "log_group_class must be STANDARD or INFREQUENT_ACCESS."
  }
}

variable "tags" {
  description = "Tags to apply to the log group."
  type        = map(string)
  default     = {}
}
