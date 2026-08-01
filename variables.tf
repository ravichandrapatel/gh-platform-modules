variable "domain" {
  description = "SES domain identity (e.g. example.com)"
  type        = string
}

variable "enable_dkim" {
  description = "Enable SES DKIM for the domain"
  type        = bool
  default     = true
}

variable "mail_from" {
  description = "Optional custom MAIL FROM settings"
  type = object({
    mail_from_domain       = string
    behavior_on_mx_failure = optional(string, "UseDefaultValue")
  })
  default = null

  validation {
    condition = var.mail_from == null ? true : contains([
      "UseDefaultValue",
      "RejectMessage",
    ], var.mail_from.behavior_on_mx_failure)
    error_message = "mail_from.behavior_on_mx_failure must be UseDefaultValue or RejectMessage."
  }
}

variable "tags" {
  description = "Tags to apply where supported"
  type        = map(string)
  default     = {}
}
