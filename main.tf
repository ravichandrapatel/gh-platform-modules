# S3 bucket notification: single notification config with optional Lambda targets and invoke permissions.

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "allow_s3" {
  for_each = var.lambda_notifications

  statement_id   = "AllowS3Invoke-${each.key}"
  action         = "lambda:InvokeFunction"
  function_name  = each.value.function_arn
  principal      = "s3.amazonaws.com"
  source_arn     = "arn:aws:s3:::${var.bucket}"
  source_account = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket_notification" "this" {
  bucket      = var.bucket
  eventbridge = var.eventbridge

  dynamic "lambda_function" {
    for_each = var.lambda_notifications

    content {
      id                  = lambda_function.key
      lambda_function_arn = lambda_function.value.function_arn
      events              = lambda_function.value.events
      filter_prefix       = try(lambda_function.value.filter_prefix, null)
      filter_suffix       = try(lambda_function.value.filter_suffix, null)
    }
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
