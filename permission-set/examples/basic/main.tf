# Basic example: one permission set with dynamic managed policies (requires existing SSO instance).

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

module "read_only_ps" {
  source = "../.."

  instance_arn = local.instance_arn
  name         = "ExampleReadOnly"
  description  = "Read-only access"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]
  tags = { Project = "Example" }
}

output "permission_set_arn" {
  value = module.read_only_ps.permission_set_arn
}

output "permission_set_id" {
  value = module.read_only_ps.permission_set_id
}
