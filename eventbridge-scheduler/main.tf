# EventBridge Scheduler: single schedule targeting an ARN (e.g. Step Functions).

resource "aws_scheduler_schedule" "this" {
  name                         = var.name
  group_name                   = var.group_name
  description                  = var.description
  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = var.schedule_expression_timezone
  state                        = var.state

  flexible_time_window {
    mode                      = var.flexible_time_window_mode
    maximum_window_in_minutes = var.flexible_time_window_mode == "FLEXIBLE" ? var.maximum_window_in_minutes : null
  }

  target {
    arn      = var.target_arn
    role_arn = var.role_arn
    input    = var.input
  }
}
