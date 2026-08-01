variable "name" {
  description = "Name of the EventBridge rule."
  type        = string
}

variable "description" {
  description = "Description of the rule."
  type        = string
  default     = null
}

variable "state" {
  description = "Whether the rule is enabled (ENABLED) or disabled (DISABLED)."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.state)
    error_message = "state must be ENABLED or DISABLED."
  }
}

variable "event_pattern" {
  description = "Event pattern JSON string. Use jsonencode({ ... }) at the caller. Example for ECS: source aws.ecs, detail-type ECS Service Action, detail.eventName / clusterArn filters — see AWS docs."
  type        = string
}

variable "target_sns_topic_arn" {
  description = "If set, send matching events to this SNS topic ARN. The topic policy must allow events.amazonaws.com to publish (use sns-topic module allow_eventbridge_publish)."
  type        = string
  default     = null
}

variable "target_id" {
  description = "Unique target identifier within the rule."
  type        = string
  default     = "SNS"
}

variable "tags" {
  description = "Tags for the EventBridge rule."
  type        = map(string)
  default     = {}
}
