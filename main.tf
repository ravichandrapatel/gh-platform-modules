# Route53 records: one or more `aws_route53_record` resources in a single hosted zone (map key = stable Terraform identifier).

locals {
  records_effective = var.records_json != null ? jsondecode(var.records_json) : var.records
}

check "records_one_source" {
  assert {
    condition = !(
      var.records_json != null && length(var.records) > 0
    )
    error_message = "Use either records_json or records, not both with non-empty records."
  }
}

check "records_non_empty" {
  assert {
    condition     = length(local.records_effective) > 0
    error_message = "Provide records (non-empty) or a non-null records_json with at least one key."
  }
}

check "records_alias_or_values" {
  assert {
    condition = alltrue([
      for _, r in local.records_effective : try(r.alias, null) != null || try(length(r.records), 0) > 0
    ])
    error_message = "Each non-alias record must have a non-empty records list."
  }

  assert {
    condition = alltrue([
      for _, r in local.records_effective : try(r.alias, null) == null || contains(["A", "AAAA"], r.type)
    ])
    error_message = "Alias records require type A or AAAA."
  }

  assert {
    condition = alltrue([
      for _, r in local.records_effective : !(try(r.weighted_routing_policy, null) != null && try(r.failover_routing_policy, null) != null)
    ])
    error_message = "Do not set both weighted_routing_policy and failover_routing_policy on the same record."
  }

  assert {
    condition = alltrue([
      for _, r in local.records_effective : try(r.weighted_routing_policy, null) == null || coalesce(try(r.set_identifier, null), "") != ""
    ])
    error_message = "weighted_routing_policy requires set_identifier on that record."
  }

  assert {
    condition = alltrue([
      for _, r in local.records_effective : try(r.failover_routing_policy, null) == null || coalesce(try(r.set_identifier, null), "") != ""
    ])
    error_message = "failover_routing_policy requires set_identifier on that record."
  }

  assert {
    condition = alltrue([
      for _, r in local.records_effective :
      try(r.failover_routing_policy, null) == null || contains(["PRIMARY", "SECONDARY"], r.failover_routing_policy.type)
    ])
    error_message = "failover_routing_policy.type must be PRIMARY or SECONDARY."
  }
}

resource "aws_route53_record" "this" {
  for_each = local.records_effective

  zone_id         = var.zone_id
  name            = each.value.name
  type            = each.value.type
  allow_overwrite = coalesce(try(each.value.allow_overwrite, null), true)

  ttl     = try(each.value.alias, null) == null ? coalesce(try(each.value.ttl, null), 300) : null
  records = try(each.value.alias, null) == null ? try(each.value.records, null) : null

  dynamic "alias" {
    for_each = try(each.value.alias, null) != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = try(alias.value.evaluate_target_health, false)
    }
  }

  health_check_id = try(coalesce(each.value.health_check_id, ""), "") != "" ? each.value.health_check_id : null

  dynamic "weighted_routing_policy" {
    for_each = try(each.value.weighted_routing_policy, null) != null ? [each.value.weighted_routing_policy] : []
    content {
      weight = weighted_routing_policy.value.weight
    }
  }

  dynamic "failover_routing_policy" {
    for_each = try(each.value.failover_routing_policy, null) != null ? [each.value.failover_routing_policy] : []
    content {
      type = failover_routing_policy.value.type
    }
  }

  set_identifier = try(coalesce(each.value.set_identifier, ""), "") != "" ? each.value.set_identifier : null
}
