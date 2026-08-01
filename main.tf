# EventBridge (CloudWatch Events) rule with optional SNS target.

resource "aws_cloudwatch_event_rule" "this" {
  name        = var.name
  description = var.description
  state       = var.state

  event_pattern = var.event_pattern

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "sns" {
  count = var.target_sns_topic_arn != null ? 1 : 0

  rule      = aws_cloudwatch_event_rule.this.name
  target_id = var.target_id
  arn       = var.target_sns_topic_arn
}
