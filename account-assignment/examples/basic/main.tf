# Basic example: one account assignment (group + permission set + account). Requires SSO instance and Identity Store group ID.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ssoadmin_instances" "main" {}

locals {
  instance_arn = tolist(data.aws_ssoadmin_instances.main.arns)[0]
}

# Replace with a real permission set ARN and Identity Store group ID (or use identitystore-group.group_id).
module "example_assignment" {
  source = "../.."

  instance_arn       = local.instance_arn
  permission_set_arn = "arn:aws:sso:::permissionSet/ssoins-xxx/ps-xxx"
  principal_type     = "GROUP"
  principal_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  target_id          = "123456789012"
}

output "assignment_id" {
  value = module.example_assignment.assignment_id
}

output "target_id" {
  value = module.example_assignment.target_id
}
