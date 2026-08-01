# Example: one hosted zone and two records (A + alias shape) in a single module.records map.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "zone" {
  source = "../../../route53-hosted-zone"

  name    = "example.com"
  comment = "Example for route53-record basic"
  tags = {
    Environment = "example"
  }
}

module "records" {
  source = "../.."

  zone_id = module.zone.zone_id

  records = {
    www = {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = ["192.0.2.1"]
    }
    # Alias example (placeholders – replace with real ALB/CloudFront DNS name + hosted zone id).
    app = {
      name = "app"
      type = "A"
      alias = {
        name                   = "d111111abcdef8.cloudfront.net"
        zone_id                = "Z2FDTNDATAQYW2"
        evaluate_target_health = false
      }
    }
  }
}

output "fqdns" {
  value = module.records.fqdns
}
