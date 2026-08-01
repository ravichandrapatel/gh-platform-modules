# Example: wire to an existing zone and certificate (values are placeholders).

module "acm_validation" {
  source = "../.."

  zone_id         = "Z1234567890ABC"
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/00000000-0000-0000-0000-000000000000"

  domain_validation_options = [
    {
      domain_name           = "*.example.com"
      resource_record_name  = "_abc123.example.com."
      resource_record_type  = "CNAME"
      resource_record_value = "_xyz.acm-validations.aws."
    }
  ]
}
