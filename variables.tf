variable "name" {
  description = "Name of the Step Functions state machine"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the state machine"
  type        = string
}

variable "definition" {
  description = "Amazon States Language (ASL) definition as a JSON string"
  type        = string
}

variable "type" {
  description = "Type of the state machine (STANDARD or EXPRESS)"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.type)
    error_message = "type must be STANDARD or EXPRESS."
  }
}

variable "tags" {
  description = "Tags to apply to the state machine"
  type        = map(string)
  default     = {}
}
