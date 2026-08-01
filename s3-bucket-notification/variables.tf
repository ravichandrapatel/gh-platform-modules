variable "bucket" {
  description = "Name of the S3 bucket to configure notifications on"
  type        = string
}

variable "lambda_notifications" {
  description = "Map of Lambda notification configurations keyed by stable id"
  type = map(object({
    function_arn  = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = {}
}

variable "eventbridge" {
  description = "Whether to enable EventBridge notifications for the bucket"
  type        = bool
  default     = false
}
