# Identity Center Account Assignments Wrapper
# Calls the account-assignment module for each entry in the assignments map.

variable "assignments" {
  description = "Map of account assignments to create."
  type = map(object({
    instance_arn       = string
    permission_set_arn = string
    principal_type     = string
    principal_id       = string
    target_id          = string
    target_type        = string
  }))
  default = {}
}

module "assignment" {
  source   = "../account-assignment"
  for_each = var.assignments

  instance_arn       = each.value.instance_arn
  permission_set_arn = each.value.permission_set_arn
  principal_type     = each.value.principal_type
  principal_id       = each.value.principal_id
  target_id          = each.value.target_id
  target_type        = each.value.target_type
}
