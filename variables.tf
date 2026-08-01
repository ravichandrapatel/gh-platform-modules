variable "name" {
  description = "Hosted zone name (FQDN), e.g. dev.example.com. or example.com. Trailing dot optional per provider resolution."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must be non-empty."
  }
}

variable "comment" {
  description = "Optional comment on the hosted zone."
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "If true, deletes all records when destroying the zone (use with care)."
  type        = bool
  default     = false
}

variable "vpc_associations" {
  description = "VPC associations for a private hosted zone. Leave empty for a public zone. At least one VPC is required when creating a private zone."
  type = list(object({
    vpc_id     = string
    vpc_region = optional(string)
  }))
  default = []
}

variable "delegation_set_id" {
  description = "Optional reusable delegation set ID (public zones only). Leave empty to omit."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags for the hosted zone."
  type        = map(string)
  default     = {}
}
