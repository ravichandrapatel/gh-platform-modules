variable "name" {
  description = "Name of the EventBridge Scheduler schedule"
  type        = string
}

variable "group_name" {
  description = "Name of the schedule group"
  type        = string
  default     = "default"
}

variable "description" {
  description = "Description of the schedule"
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "Schedule expression (e.g. rate(1 hour), cron(...))"
  type        = string
}

variable "schedule_expression_timezone" {
  description = "Timezone for the schedule expression"
  type        = string
  default     = null
}

variable "state" {
  description = "Whether the schedule is ENABLED or DISABLED"
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.state)
    error_message = "state must be ENABLED or DISABLED."
  }
}

variable "flexible_time_window_mode" {
  description = "Flexible time window mode (OFF or FLEXIBLE)"
  type        = string
  default     = "OFF"

  validation {
    condition     = contains(["OFF", "FLEXIBLE"], var.flexible_time_window_mode)
    error_message = "flexible_time_window_mode must be OFF or FLEXIBLE."
  }
}

variable "maximum_window_in_minutes" {
  description = "Maximum flexible window in minutes (required when mode is FLEXIBLE)"
  type        = number
  default     = null
}

variable "target_arn" {
  description = "ARN of the schedule target (e.g. Step Functions state machine)"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN that EventBridge Scheduler assumes to invoke the target"
  type        = string
}

variable "input" {
  description = "Optional JSON input passed to the target"
  type        = string
  default     = null
}
