# Identity Store group: single Identity Center group (use same display_name as permission set name).

resource "aws_identitystore_group" "this" {
  identity_store_id = var.identity_store_id
  display_name      = var.display_name
  description       = var.description
}
