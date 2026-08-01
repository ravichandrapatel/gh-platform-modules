variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "Custom assume role policy JSON. If not provided, will be generated from trusted_entities"
  type        = string
  default     = null
}

variable "trusted_entities" {
  description = "List of trusted entities that can assume this role. Used only if assume_role_policy is not provided"
  type = list(object({
    type        = string       # Service, AWS, Federated, etc.
    identifiers = list(string) # Service names, account IDs, etc.
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))
  default = []
}

variable "managed_policy_arns" {
  description = "List of ARNs of AWS managed policies to attach to the role"
  type        = list(string)
  default     = []
}

variable "custom_policies" {
  description = "Map of custom IAM policies to create and attach to the role"
  type = map(object({
    name        = string
    description = optional(string)
    path        = optional(string)
    policy      = string # JSON policy document
  }))
  default = {}
}

variable "inline_policies" {
  description = "List of inline policies to embed in the role"
  type = list(object({
    name   = string
    policy = string # JSON policy document
  }))
  default = []
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600
  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Max session duration must be between 3600 and 43200 seconds"
  }
}

variable "path" {
  description = "Path for the IAM role and policies"
  type        = string
  default     = "/"
}

variable "permissions_boundary" {
  description = "ARN of the permissions boundary policy"
  type        = string
  default     = null
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile for EC2"
  type        = bool
  default     = false
}

variable "instance_profile_name" {
  description = "Name of the instance profile. Defaults to role_name if not provided"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
