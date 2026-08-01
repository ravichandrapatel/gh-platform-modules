variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "target_id" {
  description = "ID of the target (instance ID, IP, or Lambda ARN depending on target_type)"
  type        = string
}

variable "port" {
  description = "Port on the target. Required for instance/ip; optional for lambda."
  type        = number
  default     = null
}

variable "availability_zone" {
  description = "Availability zone when target_type is ip (optional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
