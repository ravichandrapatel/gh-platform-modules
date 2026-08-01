variable "configuration_set_name" {
  description = "SESv2 configuration set name"
  type        = string
}

variable "tracking_options" {
  description = "Optional tracking options"
  type = object({
    custom_redirect_domain = string
    https_policy           = optional(string)
  })
  default = null
}

variable "reputation_options" {
  description = "Optional reputation options"
  type = object({
    last_fresh_start           = optional(string)
    reputation_metrics_enabled = optional(bool)
  })
  default = null
}

variable "sending_options" {
  description = "Optional sending options"
  type = object({
    sending_enabled = bool
  })
  default = null
}

variable "suppression_options" {
  description = "Optional suppression options"
  type = object({
    suppressed_reasons = list(string)
  })
  default = null

  validation {
    condition = var.suppression_options == null ? true : alltrue([
      for reason in var.suppression_options.suppressed_reasons : contains(["BOUNCE", "COMPLAINT"], reason)
    ])
    error_message = "suppressed_reasons values must be BOUNCE or COMPLAINT."
  }
}

variable "vdm_options" {
  description = "Optional VDM options"
  type = object({
    dashboard_options = optional(object({
      engagement_metrics = string
    }))
    guardian_options = optional(object({
      optimized_shared_delivery = string
    }))
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the SESv2 configuration set"
  type        = map(string)
  default     = {}
}
