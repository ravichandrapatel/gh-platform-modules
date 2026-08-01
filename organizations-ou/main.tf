# AWS Organizations OU: single organizational unit in the organization.

resource "aws_organizations_organizational_unit" "this" {
  name      = var.name
  parent_id = var.parent_id

  tags = var.tags
}
