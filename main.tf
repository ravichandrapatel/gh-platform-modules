# Organizations Units Wrapper
# Calls the organizations-ou module for each entry in the units map.

variable "units" {
  description = "Map of organizational units to create."
  type = map(object({
    name      = string
    parent_id = string
    tags      = optional(map(string), {})
  }))
  default = {}
}

module "ou" {
  source   = "../organizations-ou"
  for_each = var.units

  name      = each.value.name
  parent_id = each.value.parent_id
  tags      = each.value.tags
}

output "units" {
  value = module.ou
}
