# Current AWS account (for callers that build the distribution ARN from outputs).
data "aws_caller_identity" "current" {}

# CloudFront Function viewer-request: SPA routing (one per path_prefix).
# Function names are account-global: prefix with the distribution name so multiple
# distributions in one account can have routers for the same path prefix.
resource "aws_cloudfront_function" "router" {
  for_each = { for f in var.viewer_request_router_functions : f.path_pattern => f }

  name    = coalesce(each.value.function_name, "${var.distribution_name}-spa-router-${replace(replace(each.value.path_prefix, "/", ""), "/", "-")}")
  runtime = "cloudfront-js-1.0"
  comment = "Rewrite ${each.value.path_prefix} and route paths to ${each.value.path_prefix}/index.html"
  publish = true
  code    = templatefile("${path.module}/files/spa-router.js.tpl", { path_prefix = each.value.path_prefix })

  # Renames force replacement; create the new function before destroying the old
  # one so a live distribution association never blocks the destroy.
  lifecycle {
    create_before_destroy = true
  }
}

# Viewer-request: optional redirect for API-only hostname on "/" so default (S3) is not used.
resource "aws_cloudfront_function" "api_subdomain_root_redirect" {
  count = var.api_subdomain_root_redirect != null ? 1 : 0

  name    = "${var.distribution_name}-api-subdomain-root-redirect"
  runtime = "cloudfront-js-1.0"
  comment = "Redirect ${var.api_subdomain_root_redirect.host}/ to ${var.api_subdomain_root_redirect.root_redirect_path}"
  publish = true
  code = templatefile("${path.module}/files/api-subdomain-root-redirect.js.tpl", {
    api_host      = var.api_subdomain_root_redirect.host
    redirect_path = var.api_subdomain_root_redirect.root_redirect_path
  })
}

# Optional ALB origin + API cache behaviors. Path list: var.alb_api_path_patterns (set in root / terragrunt per environment).
# NOTE: the alb-api origin and behaviors are emitted as dedicated dynamic blocks in the
# distribution resource (not concat()-ed into var.origins/var.ordered_cache_behaviors):
# concat of a hand-built object literal with the strongly-typed variable lists panics in
# cty ("inconsistent list element types") because bare nulls in the literal are untyped.
locals {
  ordered_cache_behaviors_computed = [
    for b in var.ordered_cache_behaviors :
    merge(b, {
      function_associations = concat(
        b.function_associations,
        [for path_pattern, fn in aws_cloudfront_function.router : { event_type = "viewer-request", function_arn = fn.arn } if path_pattern == b.path_pattern]
      )
    })
  ]

  default_cache_behavior_function_associations = concat(
    var.default_cache_behavior.function_associations,
    var.api_subdomain_root_redirect != null ? [{ event_type = "viewer-request", function_arn = aws_cloudfront_function.api_subdomain_root_redirect[0].arn }] : []
  )

  # Custom error responses: use flat list if set; else use "default" path's from custom_error_responses_per_path (CloudFront allows one set per distribution).
  custom_error_responses_computed = length(var.custom_error_responses) > 0 ? var.custom_error_responses : (
    length(var.custom_error_responses_per_path) > 0 ? (
      try([for p in var.custom_error_responses_per_path : p.error_responses if p.path_pattern == "default"][0], var.custom_error_responses_per_path[0].error_responses)
    ) : []
  )
}

# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "this" {
  count = var.create_oai ? 1 : 0

  comment = var.oai_comment != "" ? var.oai_comment : "${var.distribution_name} OAI"
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "this" {
  count = var.create_oac ? 1 : 0

  name                              = var.oac_name != "" ? var.oac_name : "${var.distribution_name}-oac"
  description                       = "OAC for ${var.distribution_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = var.oac_signing_behavior
  signing_protocol                  = var.oac_signing_protocol
}

# CloudFront VPC origins (for private ALB/NLB/EC2 origins).
resource "aws_cloudfront_vpc_origin" "this" {
  for_each = {
    for o in var.origins : o.origin_id => o
    if o.vpc_origin_config != null
  }

  vpc_origin_endpoint_config {
    name                   = each.value.vpc_origin_config.name
    arn                    = each.value.vpc_origin_config.arn
    http_port              = each.value.vpc_origin_config.http_port
    https_port             = each.value.vpc_origin_config.https_port
    origin_protocol_policy = each.value.vpc_origin_config.origin_protocol_policy
    origin_ssl_protocols {
      items    = each.value.vpc_origin_config.origin_ssl_protocols.items
      quantity = each.value.vpc_origin_config.origin_ssl_protocols.quantity
    }
  }

  tags = var.tags
}

# VPC origin for the injected alb-api origin (private/internal ALB).
resource "aws_cloudfront_vpc_origin" "alb_api" {
  count = var.alb_api_origin_arn != null ? 1 : 0

  vpc_origin_endpoint_config {
    name                   = "${var.distribution_name}-alb-api"
    arn                    = var.alb_api_origin_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = var.alb_api_origin_protocol_policy
    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }

  tags = var.tags
}

check "s3_oac_when_required" {
  assert {
    condition = alltrue([
      for o in var.origins :
      try(o.vpc_origin_config, null) != null ||
      !coalesce(o.use_oac, false) ||
      var.create_oac ||
      try(trimspace(o.origin_access_control_id), "") != ""
    ])
    error_message = "For S3 origins with use_oac = true, set create_oac = true or pass a non-empty origin_access_control_id."
  }
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment != "" ? var.comment : var.distribution_name
  price_class         = var.price_class
  default_root_object = var.default_root_object
  http_version        = var.http_version
  aliases             = var.aliases
  web_acl_id          = var.web_acl_id

  # Origins
  dynamic "origin" {
    for_each = var.origins

    content {
      domain_name         = origin.value.domain_name
      origin_id           = origin.value.origin_id
      origin_path         = origin.value.origin_path
      connection_attempts = origin.value.connection_attempts
      connection_timeout  = origin.value.connection_timeout

      # OAC only on S3 origins. Use null (omit) when not applicable — empty string fails validation (e.g. VPC / custom origins).
      origin_access_control_id = (
        try(origin.value.vpc_origin_config, null) != null ? null : (
          !coalesce(origin.value.use_oac, false) ? null : (
            var.create_oac ? aws_cloudfront_origin_access_control.this[0].id : (
              try(trimspace(origin.value.origin_access_control_id), "") != "" ? origin.value.origin_access_control_id : null
            )
          )
        )
      )

      dynamic "s3_origin_config" {
        for_each = !coalesce(origin.value.use_oac, false) && origin.value.s3_origin_config != null ? [origin.value.s3_origin_config] : []
        content {
          origin_access_identity = s3_origin_config.value.origin_access_identity
        }
      }

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []

        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = custom_origin_config.value.origin_read_timeout
        }
      }

      dynamic "vpc_origin_config" {
        for_each = origin.value.vpc_origin_config != null ? [origin.value.vpc_origin_config] : []
        content {
          vpc_origin_id = aws_cloudfront_vpc_origin.this[origin.value.origin_id].id
        }
      }

      dynamic "custom_header" {
        for_each = origin.value.custom_headers != null ? origin.value.custom_headers : []

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
    }
  }

  # Injected ALB API origin (when alb_api_origin_dns_name is set).
  # With alb_api_origin_arn: VPC origin (private/internal ALB); otherwise public custom origin.
  dynamic "origin" {
    for_each = var.alb_api_origin_dns_name == null ? [] : [var.alb_api_origin_dns_name]

    content {
      domain_name         = origin.value
      origin_id           = "alb-api"
      origin_path         = ""
      connection_attempts = 3
      connection_timeout  = 10

      dynamic "vpc_origin_config" {
        for_each = var.alb_api_origin_arn != null ? [1] : []
        content {
          vpc_origin_id = aws_cloudfront_vpc_origin.alb_api[0].id
        }
      }

      dynamic "custom_origin_config" {
        for_each = var.alb_api_origin_arn == null ? [1] : []
        content {
          http_port                = 80
          https_port               = 443
          origin_protocol_policy   = var.alb_api_origin_protocol_policy
          origin_ssl_protocols     = ["TLSv1.2"]
          origin_keepalive_timeout = 60
          origin_read_timeout      = 60
        }
      }
    }
  }

  # Default Cache Behavior
  default_cache_behavior {
    target_origin_id       = var.default_cache_behavior.target_origin_id
    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods
    compress               = var.default_cache_behavior.compress

    cache_policy_id            = var.default_cache_behavior.cache_policy_id != "" ? var.default_cache_behavior.cache_policy_id : null
    origin_request_policy_id   = var.default_cache_behavior.origin_request_policy_id != "" ? var.default_cache_behavior.origin_request_policy_id : null
    response_headers_policy_id = var.default_cache_behavior.response_headers_policy_id != "" ? var.default_cache_behavior.response_headers_policy_id : null
    realtime_log_config_arn    = var.default_cache_behavior.realtime_log_config_arn != "" ? var.default_cache_behavior.realtime_log_config_arn : null

    dynamic "forwarded_values" {
      for_each = var.default_cache_behavior.cache_policy_id == "" && var.default_cache_behavior.forwarded_values != null ? [var.default_cache_behavior.forwarded_values] : []

      content {
        query_string = forwarded_values.value.query_string
        headers      = forwarded_values.value.headers

        cookies {
          forward           = forwarded_values.value.cookies.forward
          whitelisted_names = forwarded_values.value.cookies.forward == "whitelist" ? forwarded_values.value.cookies.whitelisted_names : null
        }
      }
    }

    min_ttl     = var.default_cache_behavior.cache_policy_id == "" ? var.default_cache_behavior.min_ttl : null
    default_ttl = var.default_cache_behavior.cache_policy_id == "" ? var.default_cache_behavior.default_ttl : null
    max_ttl     = var.default_cache_behavior.cache_policy_id == "" ? var.default_cache_behavior.max_ttl : null

    dynamic "function_association" {
      for_each = local.default_cache_behavior_function_associations
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.default_cache_behavior.lambda_function_associations
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }
  }

  # Injected ALB API behaviors (before user behaviors so /xxx-api* wins over /xxx*)
  dynamic "ordered_cache_behavior" {
    for_each = var.alb_api_origin_dns_name == null ? [] : var.alb_api_path_patterns

    content {
      path_pattern           = ordered_cache_behavior.value
      target_origin_id       = "alb-api"
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods         = ["GET", "HEAD"]
      compress               = true

      cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
      # https-only: forward the viewer Host (AllViewer) so CloudFront validates the
      # ALB cert against the *.rxapps360.com alias. http-only: keep Host off the
      # origin (AllViewerExceptHostHeader) so the ALB sees its own DNS as Host.
      origin_request_policy_id = var.alb_api_origin_protocol_policy == "https-only" ? "216adef6-5c7f-47e4-b989-5492eafa07d3" : "b689b0a8-53d0-40ab-baf2-68738e2966ac"
    }
  }

  # Ordered Cache Behaviors
  dynamic "ordered_cache_behavior" {
    for_each = local.ordered_cache_behaviors_computed

    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      compress               = ordered_cache_behavior.value.compress

      cache_policy_id            = ordered_cache_behavior.value.cache_policy_id != "" ? ordered_cache_behavior.value.cache_policy_id : null
      origin_request_policy_id   = ordered_cache_behavior.value.origin_request_policy_id != "" ? ordered_cache_behavior.value.origin_request_policy_id : null
      response_headers_policy_id = ordered_cache_behavior.value.response_headers_policy_id != "" ? ordered_cache_behavior.value.response_headers_policy_id : null

      dynamic "forwarded_values" {
        for_each = ordered_cache_behavior.value.cache_policy_id == "" && ordered_cache_behavior.value.forwarded_values != null ? [ordered_cache_behavior.value.forwarded_values] : []

        content {
          query_string = forwarded_values.value.query_string
          headers      = forwarded_values.value.headers

          cookies {
            forward           = forwarded_values.value.cookies.forward
            whitelisted_names = forwarded_values.value.cookies.forward == "whitelist" ? forwarded_values.value.cookies.whitelisted_names : null
          }
        }
      }

      dynamic "function_association" {
        for_each = ordered_cache_behavior.value.function_associations
        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.function_arn
        }
      }

      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_associations
        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lambda_function_association.value.include_body
        }
      }

      min_ttl     = ordered_cache_behavior.value.cache_policy_id == "" ? ordered_cache_behavior.value.min_ttl : null
      default_ttl = ordered_cache_behavior.value.cache_policy_id == "" ? ordered_cache_behavior.value.default_ttl : null
      max_ttl     = ordered_cache_behavior.value.cache_policy_id == "" ? ordered_cache_behavior.value.max_ttl : null
    }
  }

  # Custom Error Responses (one set per distribution; from custom_error_responses or "default" entry of custom_error_responses_per_path)
  dynamic "custom_error_response" {
    for_each = local.custom_error_responses_computed

    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  # SSL/TLS Configuration
  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? var.ssl_support_method : null
    minimum_protocol_version       = var.minimum_protocol_version
  }

  # Geo Restrictions
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  # Logging
  dynamic "logging_config" {
    for_each = var.logging != null && var.logging.enabled ? [var.logging] : []

    content {
      include_cookies = logging_config.value.include_cookies
      bucket          = logging_config.value.bucket
      prefix          = logging_config.value.prefix
    }
  }

  tags = var.tags

  lifecycle {
    # Do not create or modify Web ACL from this module. Ignore web_acl_id so Terraform never replaces or removes an ACL attached outside this config.
    ignore_changes = [web_acl_id]
  }
}

# Invalidation: the AWS provider has no cloudfront invalidation resource, so we use local-exec to run
# aws cloudfront create-invalidation. This runs when the distribution or router functions change (triggers).
resource "null_resource" "invalidation" {
  count = var.invalidation_paths != null && length(var.invalidation_paths) > 0 ? 1 : 0

  triggers = {
    distribution_id            = aws_cloudfront_distribution.this.id
    paths                      = join(",", var.invalidation_paths)
    router_functions_arn       = join(",", [for _, fn in aws_cloudfront_function.router : fn.arn])
    api_subdomain_redirect_arn = var.api_subdomain_root_redirect != null ? aws_cloudfront_function.api_subdomain_root_redirect[0].arn : ""
  }

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.this.id} --paths ${join(" ", formatlist("\"%s\"", var.invalidation_paths))}"
  }
}
