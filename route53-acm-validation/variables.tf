variable "zone_id" {
  description = "Route 53 hosted zone ID (public zone that is authoritative for the ACM validation record names)."
  type        = string

  validation {
    condition     = length(trimspace(var.zone_id)) > 0 && can(regex("^Z", var.zone_id))
    error_message = "zone_id must be a non-empty Route 53 hosted zone ID (starts with Z)."
  }
}

variable "certificate_arn" {
  description = "ARN of aws_acm_certificate to validate (same region as the certificate, typically us-east-1 for CloudFront)."
  type        = string
}

variable "domain_validation_options" {
  description = "ACM domain_validation_options from the certificate (pass aws_acm_certificate.this[0].domain_validation_options)."
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))

  validation {
    condition     = length(var.domain_validation_options) > 0
    error_message = "domain_validation_options must be non-empty for DNS validation."
  }
}

variable "tags" {
  description = "Tags for resources that support them (validation waiter has no tags; reserved for future use)."
  type        = map(string)
  default     = {}
}
