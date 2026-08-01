# Route53: lookup hosted zone by domain and create records (for_each). Supports alias and standard records.

# Lookup the existing Hosted Zone
data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

# --- Dynamic DNS Records ---
resource "aws_route53_record" "this" {
  for_each = var.records

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type

  # Only set TTL and Records if it is NOT an alias record
  ttl     = each.value.alias == null ? each.value.ttl : null
  records = each.value.alias == null ? each.value.records : null

  # Dynamic Alias Block
  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = lookup(alias.value, "evaluate_target_health", false)
    }
  }

  allow_overwrite = lookup(each.value, "allow_overwrite", true)
}