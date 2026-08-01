# Basic example: VPC with public and private subnets in one AZ.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "tags" {
  source      = "../../../tagging"
  environment = "NON-PROD"
  project     = "ExampleApp"
}

module "vpc" {
  source = "../.."

  vpc_name   = "example-vpc"
  cidr_block = "10.0.0.0/16"

  public_subnets = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = data.aws_availability_zones.available.names[0]
      name              = "public-1"
    }
  ]

  private_subnets = [
    {
      cidr_block        = "10.0.10.0/24"
      availability_zone = data.aws_availability_zones.available.names[0]
      name              = "private-1"
    }
  ]

  create_internet_gateway = true
  create_nat_gateway      = false

  tags = module.tags.tags
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
