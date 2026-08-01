# AWS Organizations Policy: create SCPs or Tag Policies.

resource "aws_organizations_policy" "this" {
  name        = var.name
  content     = var.content
  type        = var.type
  description = var.description

  tags = var.tags
}

variable "name" {
  description = "The name of the policy."
  type        = string
}

variable "content" {
  description = "The JSON content of the policy."
  type        = string
}

variable "type" {
  description = "The type of policy. One of SERVICE_CONTROL_POLICY, TAG_POLICY, BACKUP_POLICY, or AISERVICES_OPT_OUT_POLICY."
  type        = string
  default     = "SERVICE_CONTROL_POLICY"
}

variable "description" {
  description = "A description of the policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to the policy."
  type        = map(string)
  default     = {}
}

output "id" {
  description = "The ID of the policy."
  value       = aws_organizations_policy.this.id
}

output "arn" {
  description = "The ARN of the policy."
  value       = aws_organizations_policy.this.arn
}
