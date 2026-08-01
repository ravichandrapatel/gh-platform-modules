# account-assignment module - Terraform and AWS provider version constraints.
# One resource: one IAM Identity Center account assignment.

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
