# Basic example: CloudFront distribution with custom origin. Replace origin domain for real use.

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

module "cloudfront" {
  source = "../.."

  distribution_name = "example-dist"

  origins = [
    {
      origin_id   = "custom"
      domain_name = "example.com"
      origin_path = ""

      s3_origin_config = {
        origin_access_identity   = ""
        origin_access_control_id = ""
      }

      custom_origin_config = {
        http_port                = 80
        https_port               = 443
        origin_protocol_policy   = "https-only"
        origin_ssl_protocols     = ["TLSv1.2"]
        origin_keepalive_timeout = 60
        origin_read_timeout      = 60
      }

      custom_headers = []
      origin_shield  = { enabled = false, origin_shield_region = "" }
    }
  ]

  default_cache_behavior = {
    target_origin_id       = "custom"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id   = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
    realtime_log_config_arn    = ""

    forwarded_values = {
      query_string = false
      headers      = []
      cookies      = { forward = "none", whitelisted_names = [] }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    function_associations        = []
    lambda_function_associations = []
  }

  ordered_cache_behaviors = []
  custom_error_responses  = []

  tags = module.tags.tags
}

output "distribution_id" {
  value = module.cloudfront.distribution_id
}

output "distribution_arn" {
  value = module.cloudfront.distribution_arn
}

output "distribution_domain_name" {
  value = module.cloudfront.distribution_domain_name
}
