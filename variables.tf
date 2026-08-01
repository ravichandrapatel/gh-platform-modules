variable "name" {
  description = "Name of the SNS topic. Exactly one of name or name_prefix must be set."
  type        = string
  default     = null

  validation {
    condition     = (var.name != null && var.name_prefix == null) || (var.name == null && var.name_prefix != null)
    error_message = "Exactly one of name or name_prefix must be set."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with this prefix. Exactly one of name or name_prefix must be set."
  type        = string
  default     = null
}

variable "display_name" {
  description = "Display name for SMS subscriptions (optional)."
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "KMS key ID or ARN for server-side encryption of topic contents."
  type        = string
  default     = null
}

variable "subscriptions" {
  description = "Map of subscription key → protocol and endpoint (e.g. email, https, sqs, lambda)."
  type = map(object({
    protocol = string
    endpoint = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, s in var.subscriptions :
      contains(["email", "email-json", "http", "https", "sms", "sqs", "application", "lambda"], s.protocol)
    ])
    error_message = "Each subscription protocol must be a valid SNS protocol."
  }
}

variable "allow_eventbridge_publish" {
  description = "If true, attach a topic policy allowing events.amazonaws.com to sns:Publish from this account (for EventBridge → SNS targets)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the SNS topic."
  type        = map(string)
  default     = {}
}
