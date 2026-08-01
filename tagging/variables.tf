variable "environment" {
  description = "Environment name (allowed values: PROD, NON-PROD, ACPT)"
  type        = string
  validation {
    condition     = contains(["PROD", "NON-PROD", "ACPT"], upper(var.environment))
    error_message = "environment must be one of: PROD, NON-PROD, ACPT"
  }
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "cost_center" {
  description = "Cost center tag value"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Owner tag value"
  type        = string
  default     = ""
}

variable "tier" {
  description = "Tier tag value (allowed: frontend, middleware, database)"
  type        = string
  default     = ""
  validation {
    condition     = var.tier == "" || contains(["frontend", "middleware", "database"], var.tier)
    error_message = "tier must be one of: frontend, middleware, database (or empty)"
  }
}

variable "resource" {
  description = "AWS resource type or logical name for the Resource tag (e.g. vpc, ecs, s3, ecr, acm, alb)"
  type        = string
  default     = ""
}
