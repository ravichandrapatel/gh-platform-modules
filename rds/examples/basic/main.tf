# Basic example: RDS instance (MySQL). Replace subnets, security_groups, and password for real use.

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
  name   = "example-rds-sg"
  vpc_id = data.aws_vpc.default.id
  ingress_rules = {
    mysql = {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }
  }
  tags = module.tags.tags
}

module "rds" {
  source = "../.."

  identifier        = "example-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  database_name   = "example"
  master_username = "admin"
  master_password = "ReplaceMeWithSecurePassword"

  vpc_id              = data.aws_vpc.default.id
  subnet_ids          = data.aws_subnets.default.ids
  security_group_ids  = [module.sg.security_group_id]
  publicly_accessible = false

  skip_final_snapshot = true

  tags = module.tags.tags
}

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "db_instance_id" {
  value = module.rds.db_instance_id
}
