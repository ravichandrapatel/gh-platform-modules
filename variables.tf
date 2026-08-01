variable "distribution_name" {
  description = "Name of the CloudFront distribution"
  type        = string
}

variable "enabled" {
  description = "Enable CloudFront distribution"
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class for CloudFront distribution. Set to null to omit (required for distributions on the Free pricing plan, which cannot have Price class set)."
  type        = string
  default     = null
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "http_version" {
  description = "Maximum HTTP version (http1.1, http2, http2and3, http3)"
  type        = string
  default     = "http2and3"
}

variable "is_ipv6_enabled" {
  description = "Enable IPv6"
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comment for the distribution"
  type        = string
  default     = ""
}

variable "web_acl_id" {
  description = "WAF Web ACL ID (optional). This module does not create or modify Web ACLs; pass only if the distribution already has one. Terraform lifecycle ignore_changes prevents changing it."
  type        = string
  default     = null
}

variable "create_oai" {
  description = "Create Origin Access Identity for S3 origins"
  type        = bool
  default     = false
}

variable "oai_comment" {
  description = "Comment for Origin Access Identity"
  type        = string
  default     = ""
}

variable "create_oac" {
  description = "Create Origin Access Control for S3 origins"
  type        = bool
  default     = false
}

variable "oac_name" {
  description = "Name for Origin Access Control"
  type        = string
  default     = ""
}

variable "oac_signing_behavior" {
  description = "Signing behavior for OAC (always, never, no-override)"
  type        = string
  default     = "always"
}

variable "oac_signing_protocol" {
  description = "Signing protocol for OAC (sigv4)"
  type        = string
  default     = "sigv4"
}

variable "alb_api_origin_dns_name" {
  description = "Optional ALB DNS name; API behaviors use alb_api_path_patterns → alb-api origin. When null, no ALB origin or API behaviors."
  type        = string
  nullable    = true
  default     = null
}

variable "alb_api_origin_arn" {
  description = "Optional ALB ARN for the alb-api origin. When set (with alb_api_origin_dns_name), CloudFront reaches the ALB through a VPC origin so the ALB can be internal/private. When null, the alb-api origin is a public custom origin."
  type        = string
  nullable    = true
  default     = null
}

variable "alb_api_origin_protocol_policy" {
  description = "Protocol CloudFront uses to reach the alb-api origin: 'http-only' (CloudFront→ALB over HTTP:80) or 'https-only' (over HTTPS:443). With 'https-only' the alb-api behaviors forward the viewer Host header so CloudFront validates the ALB certificate against that Host — the distribution MUST therefore use an alias covered by the ALB certificate (e.g. a *.rxapps360.com alias), otherwise CloudFront returns 502 on a cert mismatch."
  type        = string
  default     = "http-only"
  validation {
    condition     = contains(["http-only", "https-only"], var.alb_api_origin_protocol_policy)
    error_message = "alb_api_origin_protocol_policy must be 'http-only' or 'https-only'."
  }
}

variable "alb_api_path_patterns" {
  description = "Ordered path patterns sent to the ALB API origin when alb_api_origin_dns_name is set. Define in the caller (Terragrunt), not hardcoded per microservice in the module."
  type        = list(string)
  default = [
    "/rxcatalog-api*",
    "/rxplan-api*",
    "/rxasset-api*",
    "/rxpo-api*",
    "/core-api*",
  ]
}

variable "origins" {
  description = "List of origins for the distribution"
  type = list(object({
    origin_id                = string
    domain_name              = string
    origin_path              = optional(string, "")
    connection_attempts      = optional(number, 3)
    connection_timeout       = optional(number, 10)
    use_oac                  = optional(bool, false)
    origin_access_control_id = optional(string, "")

    s3_origin_config = optional(object({
      origin_access_identity   = string
      origin_access_control_id = optional(string, "")
    }), null)

    custom_origin_config = optional(object({
      http_port                = number
      https_port               = number
      origin_protocol_policy   = string
      origin_ssl_protocols     = list(string)
      origin_keepalive_timeout = number
      origin_read_timeout      = number
    }), null)

    custom_headers = optional(list(object({
      name  = string
      value = string
    })), null)

    origin_shield = optional(object({
      enabled              = bool
      origin_shield_region = string
    }), null)

    vpc_origin_config = optional(object({
      name                   = string
      arn                    = string
      http_port              = optional(number, 80)
      https_port             = optional(number, 443)
      origin_protocol_policy = optional(string, "https-only")
      origin_ssl_protocols = optional(object({
        items    = list(string)
        quantity = number
        }), {
        items    = ["TLSv1.2"]
        quantity = 1
      })
    }), null)
  }))
}

variable "default_cache_behavior" {
  description = "Default cache behavior"
  type = object({
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = bool

    cache_policy_id            = string
    origin_request_policy_id   = string
    response_headers_policy_id = string
    realtime_log_config_arn    = string

    forwarded_values = object({
      query_string = bool
      headers      = list(string)
      cookies = object({
        forward           = string
        whitelisted_names = list(string)
      })
    })

    min_ttl     = number
    default_ttl = number
    max_ttl     = number

    function_associations = list(object({
      event_type   = string
      function_arn = string
    }))

    lambda_function_associations = list(object({
      event_type   = string
      lambda_arn   = string
      include_body = bool
    }))
  })
}

variable "ordered_cache_behaviors" {
  description = "Ordered cache behaviors"
  type = list(object({
    path_pattern           = string
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = bool

    cache_policy_id            = string
    origin_request_policy_id   = string
    response_headers_policy_id = string

    forwarded_values = object({
      query_string = bool
      headers      = list(string)
      cookies = object({
        forward           = string
        whitelisted_names = list(string)
      })
    })

    min_ttl     = number
    default_ttl = number
    max_ttl     = number

    function_associations = list(object({
      event_type   = string
      function_arn = string
    }))

    lambda_function_associations = list(object({
      event_type   = string
      lambda_arn   = string
      include_body = bool
    }))
  }))
  default = []
}

variable "custom_error_responses" {
  description = "Custom error responses (single set for the distribution). Prefer custom_error_responses_per_path for per-path config."
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = []
}

# Per-path custom error responses. CloudFront supports only one set per distribution; the entry with path_pattern \"default\" is used for the distribution. Other entries are for clarity and future use (e.g. Lambda@Edge).
variable "custom_error_responses_per_path" {
  description = "Custom error responses per path. Use path_pattern = \"default\" for the root/default behavior; that entry's error_responses are applied at distribution level. Other paths document intent (CloudFront does not support per-behavior error pages)."
  type = list(object({
    path_pattern = string
    error_responses = list(object({
      error_code            = number
      response_code         = number
      response_page_path    = string
      error_caching_min_ttl = number
    }))
  }))
  default = []
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for custom domain"
  type        = string
  default     = null
}

variable "aliases" {
  description = "Alternate domain names (CNAMEs)"
  type        = list(string)
  default     = []
}

variable "minimum_protocol_version" {
  description = "Minimum TLS protocol version"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "ssl_support_method" {
  description = "SSL support method (sni-only or vip)"
  type        = string
  default     = "sni-only"
}

variable "geo_restriction_type" {
  description = "Geo restriction type (none, whitelist, blacklist)"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "Country codes for geo restriction"
  type        = list(string)
  default     = []
}

variable "logging" {
  description = "Logging configuration"
  type = object({
    enabled         = bool
    include_cookies = bool
    bucket          = string
    prefix          = string
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the CloudFront distribution"
  type        = map(string)
  default     = {}
}

# Optional CloudFront Function viewer-request for path-based SPA routing (one per origin/path).
variable "viewer_request_router_functions" {
  description = "List of { path_pattern, path_prefix, optional function_name } to create a CloudFront Function (viewer-request) that rewrites path_prefix and route-like paths to path_prefix/index.html. One function is created per entry and attached to the cache behavior with the matching path_pattern. When function_name is omitted, defaults to \"{distribution_name}-spa-router-{path_prefix without slashes}\"."
  type = list(object({
    path_pattern  = string
    path_prefix   = string
    function_name = optional(string)
  }))
  default = []
}

# Optional paths to invalidate when the distribution or router functions are updated.
variable "invalidation_paths" {
  description = "Optional list of path patterns to invalidate after the distribution is updated (triggers a local-exec create-invalidation; the AWS provider has no invalidation resource). Example: [\"/rxcatalog*\"]."
  type        = list(string)
  default     = null
}

# Optional: same CloudFront distribution serves SPA (S3 default) and API (VPC origin). Browser Host api.example.com
# with path "/" would otherwise hit the default behavior (S3). When set, a viewer-request function redirects GET / only.
variable "api_subdomain_root_redirect" {
  description = "When non-null, attach a CloudFront Function to the default cache behavior: for this Host header (case-insensitive) and URI exactly '/', return 302 to https://<host><root_redirect_path> (path your ALB serves, e.g. /health)."
  type = object({
    host               = string
    root_redirect_path = string
  })
  default = null
}

