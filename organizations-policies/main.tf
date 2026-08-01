# Organizations Policies Wrapper
# Manages multiple policies and their attachments.

variable "policies" {
  description = "Map of policies to create."
  type = map(object({
    name        = string
    content     = string
    type        = string
    description = optional(string)
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "attachments" {
  description = "List of policy attachments."
  type = list(object({
    policy_key = string
    target_id  = string
  }))
  default = []
}

module "policy" {
  source   = "../organizations-policy"
  for_each = var.policies

  name        = each.value.name
  content     = each.value.content
  type        = each.value.type
  description = each.value.description
  tags        = each.value.tags
}

module "attachment" {
  source = "../organizations-policy-attachment"
  count  = length(var.attachments)

  policy_id = module.policy[var.attachments[count.index].policy_key].id
  target_id = var.attachments[count.index].target_id
}

output "policies" {
  value = module.policy
}
