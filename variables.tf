variable "zone_id" {
  description = "ID of the hosted zone (aws_route53_zone.this.zone_id or data source)."
  type        = string
}

variable "records" {
  description = "Map of logical keys (stable identifiers) to record definitions. Ignored when records_json is non-null."
  type = map(object({
    name            = string
    type            = string
    ttl             = optional(number, 300)
    records         = optional(list(string))
    allow_overwrite = optional(bool)
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool)
    }))
    health_check_id = optional(string)
    set_identifier  = optional(string)
    weighted_routing_policy = optional(object({
      weight = number
    }))
    failover_routing_policy = optional(object({
      type = string
    }))
  }))
  default = {}
}

variable "records_json" {
  description = "JSON document with the same structure as var.records (object maps). Use from Terragrunt when dependency outputs cannot be nested in an HCL object (build JSON with format/jsonencode on dependency values only)."
  type        = string
  default     = null
  nullable    = true
}
