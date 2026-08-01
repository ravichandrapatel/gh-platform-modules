# Basic example: Route53 records in an existing hosted zone. Replace domain_name with your zone.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "route53" {
  source = "../.."

  domain_name = "example.com."

  records = {
    www = {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = ["192.0.2.1"]
    }
  }
}

output "zone_id" {
  value = module.route53.zone_id
}

output "record_fqdns" {
  value = module.route53.record_fqdns
}
