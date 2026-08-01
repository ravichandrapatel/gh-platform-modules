# Identity Store Groups Wrapper
# Calls the identitystore-group module for each entry in the groups map.

variable "groups" {
  description = "Map of groups to create."
  type = map(object({
    identity_store_id = string
    display_name      = string
    description       = string
  }))
  default = {}
}

module "group" {
  source   = "../identitystore-group"
  for_each = var.groups

  identity_store_id = each.value.identity_store_id
  display_name      = each.value.display_name
  description       = each.value.description
}

output "groups" {
  value = module.group
}
