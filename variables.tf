variable "aws_service_access_principals" {
  description = "List of AWS service principal names for which you want to enable integration with your organization."
  type        = list(string)
  default     = []
}

variable "enabled_policy_types" {
  description = "List of Organizations policy types to enable in the Organization Root."
  type        = list(string)
  default     = []
}

variable "feature_set" {
  description = "The feature set of the organization. One of ALL or CONSOLIDATED_BILLING."
  type        = string
  default     = "ALL"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
