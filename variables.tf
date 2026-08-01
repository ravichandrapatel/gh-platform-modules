variable "email_identity" {
  description = "SES email identity (email address or domain)"
  type        = string
}

variable "dkim_signing_attributes" {
  description = "Optional DKIM signing attributes for BYODKIM"
  type = object({
    domain_signing_private_key = optional(string)
    domain_signing_selector    = optional(string)
    next_signing_key_length    = optional(string)
  })
  default = null

  validation {
    condition = var.dkim_signing_attributes == null ? true : (
      try(var.dkim_signing_attributes.next_signing_key_length, null) == null ||
      contains(["RSA_1024_BIT", "RSA_2048_BIT"], var.dkim_signing_attributes.next_signing_key_length)
    )
    error_message = "next_signing_key_length must be RSA_1024_BIT or RSA_2048_BIT when set."
  }
}

variable "tags" {
  description = "Tags to apply to the SES email identity"
  type        = map(string)
  default     = {}
}
