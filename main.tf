# SNS topic: one topic with optional subscriptions and optional EventBridge publish policy.

data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "this" {
  name        = var.name_prefix != null ? null : var.name
  name_prefix = var.name_prefix

  display_name      = var.display_name
  kms_master_key_id = var.kms_master_key_id

  tags = var.tags
}

# Optional subscriptions (email, https, sqs, lambda, etc.).
resource "aws_sns_topic_subscription" "this" {
  for_each = var.subscriptions

  topic_arn = aws_sns_topic.this.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}

# Let EventBridge rules in this account publish to the topic (for aws_cloudwatch_event_target → SNS).
resource "aws_sns_topic_policy" "eventbridge" {
  count = var.allow_eventbridge_publish ? 1 : 0

  arn = aws_sns_topic.this.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEventBridgePublish"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.this.arn
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}
