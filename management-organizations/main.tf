# AWS Organization Data: provides IDs for existing organization, OUs, and accounts.

data "aws_organizations_organization" "this" {}

data "aws_organizations_organizational_units" "root" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

locals {
  # Create a map of account names to IDs for easy lookup
  accounts = {
    for account in data.aws_organizations_organization.this.accounts :
    lower(replace(account.name, " ", "_")) => account.id
  }
}

output "master_account_id" {
  value = data.aws_organizations_organization.this.master_account_id
}

output "organization_id" {
  value = data.aws_organizations_organization.this.id
}

output "accounts" {
  value = local.accounts
}

output "roots" {
  value = data.aws_organizations_organization.this.roots
}

output "organizational_units" {
  value = data.aws_organizations_organizational_units.root.children
}
