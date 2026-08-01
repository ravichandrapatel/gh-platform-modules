resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  dynamic "condition" {
    for_each = var.path_pattern != null ? [1] : []
    content {
      path_pattern {
        values = [var.path_pattern]
      }
    }
  }

  dynamic "condition" {
    for_each = var.host_header != null && length(var.host_header) > 0 ? [1] : []
    content {
      host_header {
        values = var.host_header
      }
    }
  }

  tags = var.tags
}
