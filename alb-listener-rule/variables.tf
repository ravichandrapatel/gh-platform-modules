variable "listener_arn" {
  description = "ARN of the ALB listener (HTTP or HTTPS)"
  type        = string
}

variable "priority" {
  description = "Rule priority (1-50000, unique per listener)"
  type        = number
}

variable "target_group_arn" {
  description = "ARN of the target group to forward to"
  type        = string
}

variable "path_pattern" {
  description = "Path pattern for the rule (e.g. /api/*). Set one of path_pattern or host_header."
  type        = string
  default     = null
}

variable "host_header" {
  description = "Host header value(s) for the rule. Set one of path_pattern or host_header."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
