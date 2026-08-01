# Example: public hosted zone. Replace name with a domain you control before apply.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "public_zone" {
  source = "../.."

  name    = "example.com"
  comment = "Example public zone"
  tags = {
    Environment = "example"
    ManagedBy   = "terraform"
  }
}

output "zone_id" {
  value = module.public_zone.zone_id
}

output "name_servers" {
  value = module.public_zone.name_servers
}
