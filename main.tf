# Route53: ACM DNS validation records and aws_acm_certificate_validation (waits until certificate is ISSUED).

resource "aws_route53_record" "validation" {
  for_each = {
    for opt in var.domain_validation_options : opt.resource_record_name => opt
  }

  zone_id         = var.zone_id
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  records         = [each.value.resource_record_value]
  ttl             = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}
