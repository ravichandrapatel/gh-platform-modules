# identitystore-group module - Terraform and AWS provider version constraints.
# One resource: one Identity Center (Identity Store) group.

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
