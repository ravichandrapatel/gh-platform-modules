variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = null
}

variable "role_arn" {
  description = "IAM role ARN for the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime (e.g. python3.12, nodejs20.x)"
  type        = string
  default     = "python3.12"
}

variable "handler" {
  description = "Lambda handler (e.g. handler.handler)"
  type        = string
  default     = "handler.handler"
}

variable "filename" {
  description = "Path to deployment package zip. If null, a stub Python package is built in-module."
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the package. Computed automatically for stub packages; set when providing filename."
  type        = string
  default     = null
}

variable "timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 30

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "timeout must be between 1 and 900 seconds."
  }
}

variable "memory_size" {
  description = "Amount of memory in MB"
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "memory_size must be between 128 and 10240 MB."
  }
}

variable "environment_variables" {
  description = "Map of environment variables"
  type        = map(string)
  default     = {}
}

variable "architectures" {
  description = "Instruction set architecture"
  type        = list(string)
  default     = ["x86_64"]
}

variable "publish" {
  description = "Whether to publish creation/change as a new Lambda version"
  type        = bool
  default     = false
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions (-1 for unreserved)"
  type        = number
  default     = -1
}

variable "layers" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the Lambda function"
  type        = map(string)
  default     = {}
}
