# Identity Center Permission Sets Wrapper
# Calls the permission-set module for each entry in the permission_sets map.

variable "permission_sets" {
  description = "Map of permission sets to create."
  type = map(object({
    instance_arn        = string
    name                = string
    description         = string
    managed_policy_arns = list(string)
    inline_policy       = optional(string)
  }))
  default = {}
}

module "permission_set" {
  source   = "../permission-set"
  for_each = var.permission_sets

  instance_arn        = each.value.instance_arn
  name                = each.value.name
  description         = each.value.description
  managed_policy_arns = each.value.managed_policy_arns
  inline_policy       = try(each.value.inline_policy, null)
}

output "permission_sets" {
  value = module.permission_set
}
