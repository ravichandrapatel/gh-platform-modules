# Basic example: one Identity Center group (requires existing Identity Center with Identity Store).

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
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}

module "developers_group" {
  source = "../.."

  identity_store_id = local.identity_store_id
  display_name      = "Developers"
  description       = "Developers group for Identity Center"
}

output "group_id" {
  value = module.developers_group.group_id
}

output "display_name" {
  value = module.developers_group.display_name
}
