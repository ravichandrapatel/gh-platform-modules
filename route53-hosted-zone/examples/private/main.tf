# Example: private hosted zone linked to the account default VPC (replace vpc_id for real use).

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

module "private_zone" {
  source = "../.."

  name    = "corp.internal"
  comment = "Split-horizon private zone"
  vpc_associations = [
    { vpc_id = data.aws_vpc.default.id }
  ]
  tags = {
    Environment = "example"
    ManagedBy   = "terraform"
  }
}

output "zone_id" {
  value = module.private_zone.zone_id
}
