variable "domain_name" {
  description = "The hosted zone domain name (e.g. example.com.). Used to lookup the Route53 zone."
  type        = string
}

variable "records" {
  description = "A map of records to create. Supports both standard and alias records."
  type = map(object({
    name            = string
    type            = string
    ttl             = optional(number)
    records         = optional(list(string))
    allow_overwrite = optional(bool)
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool)
    }))
  }))
  default = {}
}