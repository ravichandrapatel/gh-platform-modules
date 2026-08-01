# Basic example: ALB with default target group. Use with ECS by passing target_group_arn.

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

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "tags" {
  source      = "../../../tagging"
  environment = "NON-PROD"
  project     = "ExampleApp"
}

module "sg" {
  source = "../../../security-group"
  name   = "example-alb-sg"
  vpc_id = data.aws_vpc.default.id
  ingress_rules = {
    http  = { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
    https = { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  }
  tags = module.tags.tags
}

module "alb" {
  source = "../.."

  name               = "example-alb"
  internal           = false
  vpc_id             = data.aws_vpc.default.id
  subnets            = data.aws_subnets.default.ids
  security_group_ids = [module.sg.security_group_id]

  target_port = 80
  target_type = "ip"

  tags = module.tags.tags
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}
