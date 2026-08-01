variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "ingress_rules" {
  description = "Map of ingress rules (key = unique rule id). Rendered as dynamic ingress blocks on the security group."
  type = map(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string), [])
    ipv6_cidr_blocks         = optional(list(string), [])
    source_security_group_id = optional(string, "")
    self                     = optional(bool, false)
    description              = optional(string, "")
  }))
  default = {}
}

variable "egress_rules" {
  description = "Map of egress rules (key = unique rule id). Rendered as dynamic egress blocks on the security group."
  type = map(object({
    from_port                     = number
    to_port                       = number
    protocol                      = string
    cidr_blocks                   = optional(list(string), [])
    ipv6_cidr_blocks              = optional(list(string), [])
    destination_security_group_id = optional(string, "")
    self                          = optional(bool, false)
    description                   = optional(string, "")
  }))
  default = {}
}

variable "create_default_egress" {
  description = "Create default egress rule (allow all outbound) when no egress_rules provided"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}
