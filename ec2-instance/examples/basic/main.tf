# Basic example: EC2 instance in a private subnet with SSM instance profile.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "tags" {
  source      = "../../../tagging"
  environment = "NON-PROD"
  project     = "ExampleApp"
}

module "instance" {
  source = "../.."

  name                        = "example-db-tunnel"
  instance_type               = "t4g.micro"
  subnet_id                   = "subnet-0123456789abcdef0"
  security_group_ids          = ["sg-0123456789abcdef0"]
  iam_instance_profile        = "example-db-tunnel-role"
  associate_public_ip_address = false

  tags = module.tags.tags
}

output "instance_id" {
  value = module.instance.instance_id
}
