# AWS Organizations Account: single account in the organization.

resource "aws_organizations_account" "this" {
  name                       = var.name
  email                      = var.email
  parent_id                  = var.parent_id
  role_name                  = var.role_name
  iam_user_access_to_billing = var.iam_user_access_to_billing

  tags = var.tags
}
