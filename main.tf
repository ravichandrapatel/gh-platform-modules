# SESv2 configuration set: single configuration set with optional nested settings.

resource "aws_sesv2_configuration_set" "this" {
  configuration_set_name = var.configuration_set_name

  dynamic "tracking_options" {
    for_each = var.tracking_options != null ? [var.tracking_options] : []
    content {
      custom_redirect_domain = tracking_options.value.custom_redirect_domain
      https_policy           = try(tracking_options.value.https_policy, null)
    }
  }

  dynamic "reputation_options" {
    for_each = var.reputation_options != null ? [var.reputation_options] : []
    content {
      last_fresh_start           = try(reputation_options.value.last_fresh_start, null)
      reputation_metrics_enabled = try(reputation_options.value.reputation_metrics_enabled, null)
    }
  }

  dynamic "sending_options" {
    for_each = var.sending_options != null ? [var.sending_options] : []
    content {
      sending_enabled = sending_options.value.sending_enabled
    }
  }

  dynamic "suppression_options" {
    for_each = var.suppression_options != null ? [var.suppression_options] : []
    content {
      suppressed_reasons = suppression_options.value.suppressed_reasons
    }
  }

  dynamic "vdm_options" {
    for_each = var.vdm_options != null ? [var.vdm_options] : []
    content {
      dynamic "dashboard_options" {
        for_each = try(vdm_options.value.dashboard_options, null) != null ? [vdm_options.value.dashboard_options] : []
        content {
          engagement_metrics = dashboard_options.value.engagement_metrics
        }
      }

      dynamic "guardian_options" {
        for_each = try(vdm_options.value.guardian_options, null) != null ? [vdm_options.value.guardian_options] : []
        content {
          optimized_shared_delivery = guardian_options.value.optimized_shared_delivery
        }
      }
    }
  }

  tags = var.tags
}
