# Application Load Balancer
resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnets

  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  idle_timeout                     = var.idle_timeout

  tags = var.tags
}

# Default Target Group
resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg"
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = true
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    matcher             = "200-299"
  }

  deregistration_delay = var.deregistration_delay

  tags = var.tags
}

# Additional Target Groups (path/host-based routing). for_each required: each TG is a separate resource.
resource "aws_lb_target_group" "extra" {
  for_each = var.additional_target_groups

  name        = "${var.name}-tg-${each.key}"
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_type

  health_check {
    enabled             = true
    path                = each.value.health_check_path
    interval            = each.value.health_check_interval
    timeout             = each.value.health_check_timeout
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    matcher             = each.value.matcher
  }

  deregistration_delay = each.value.deregistration_delay

  tags = var.tags
}

locals {
  # Map of target_group_key -> ARN for listener rules and outputs
  target_group_arns = merge(
    { "default" = aws_lb_target_group.this.arn },
    { for k, tg in aws_lb_target_group.extra : k => tg.arn }
  )
}

# HTTP Listener: redirect all to HTTPS, or fixed_response_404 with redirect-by-host rules
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = local.http_default_action_type

    dynamic "redirect" {
      for_each = local.http_default_action_type == "redirect" ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "fixed_response" {
      for_each = local.http_default_action_type == "fixed-response" ? [1] : []
      content {
        content_type = "text/plain"
        message_body = "Not Found"
        status_code  = "404"
      }
    }

    target_group_arn = local.http_default_action_type == "forward" ? aws_lb_target_group.this.arn : null
  }

  tags = var.tags
}

locals {
  http_default_action_type = var.acm_certificate_arn == "" ? "forward" : (
    var.http_default_action == "fixed_response_404" ? "fixed-response" : "redirect"
  )
}

# HTTP listener rules: redirect specific hosts to HTTPS (when http_default_action = fixed_response_404)
resource "aws_lb_listener_rule" "http_redirect_host" {
  for_each = var.acm_certificate_arn != "" && var.http_default_action == "fixed_response_404" ? toset(var.http_redirect_hosts) : toset([])

  listener_arn = aws_lb_listener.http.arn
  priority     = 1 + index(var.http_redirect_hosts, each.value)

  action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [each.value]
    }
  }

  tags = var.tags
}

# HTTPS Listener (if certificate is provided)
resource "aws_lb_listener" "https" {
  count = var.acm_certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = var.https_default_action == "fixed_response_404" ? "fixed-response" : "forward"

    dynamic "fixed_response" {
      for_each = var.https_default_action == "fixed_response_404" ? [1] : []
      content {
        content_type = "text/plain"
        message_body = "Not Found"
        status_code  = "404"
      }
    }

    target_group_arn = var.https_default_action == "forward" ? aws_lb_target_group.this.arn : null
  }

  tags = var.tags
}

# Listener rules: each rule is a separate resource; condition blocks use dynamic. for_each required for multiple rules.
resource "aws_lb_listener_rule" "this" {
  for_each = {
    for i, r in var.listener_rules : i => r
    if(r.listener_port == 443 && var.acm_certificate_arn != "") || r.listener_port == 80
  }

  listener_arn = each.value.listener_port == 443 ? aws_lb_listener.https[0].arn : aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = local.target_group_arns[each.value.target_group_key]
  }

  dynamic "condition" {
    for_each = try(each.value.path_pattern, null) != null && try(each.value.path_pattern, "") != "" ? [1] : []
    content {
      path_pattern {
        values = [each.value.path_pattern]
      }
    }
  }

  dynamic "condition" {
    for_each = try(each.value.host_header, null) != null && try(each.value.host_header, "") != "" ? [1] : []
    content {
      host_header {
        values = [each.value.host_header]
      }
    }
  }

  tags = var.tags
}
