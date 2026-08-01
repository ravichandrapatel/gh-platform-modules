variable "enable" {
  description = "Whether the GuardDuty detector is enabled"
  type        = bool
  default     = true
}

variable "finding_publishing_frequency" {
  description = "Finding publishing frequency for the detector (ignored after import if AWS differs)"
  type        = string
  default     = "SIX_HOURS"

  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "finding_publishing_frequency must be FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS."
  }
}

variable "tags" {
  description = "Tags applied to the detector (GuardDuty detectors do not support tags in all API versions; reserved for future use)"
  type        = map(string)
  default     = {}
}
