# Basic example: security group with ingress/egress via dynamic blocks.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

module "tags" {
  source      = "../../../tagging"
  environment = "NON-PROD"
  project     = "ExampleApp"
}

module "sg" {
  source = "../.."

  name        = "example-sg"
  description = "Example security group"
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    }
  }

  tags = module.tags.tags
}

output "security_group_id" {
  value = module.sg.security_group_id
}
