# Lambda function: single function with optional stub zip when filename is unset.

locals {
  use_stub = var.filename == null
}

data "archive_file" "stub" {
  count = local.use_stub ? 1 : 0

  type        = "zip"
  output_path = "${path.module}/builds/stub-${var.function_name}.zip"

  source {
    content  = <<-EOT
      def handler(event, context):
          return {"statusCode": 200, "body": "stub"}
    EOT
    filename = "handler.py"
  }
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  role          = var.role_arn
  runtime       = var.runtime
  handler       = var.handler
  timeout       = var.timeout
  memory_size   = var.memory_size
  architectures = var.architectures
  publish       = var.publish
  layers        = length(var.layers) > 0 ? var.layers : null

  filename         = local.use_stub ? data.archive_file.stub[0].output_path : var.filename
  source_code_hash = local.use_stub ? data.archive_file.stub[0].output_base64sha256 : var.source_code_hash

  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  tags = var.tags
}
