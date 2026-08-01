# Permission set: single Identity Center permission set with managed and optional inline policy.

resource "aws_ssoadmin_permission_set" "this" {
  instance_arn     = var.instance_arn
  name             = var.name
  description      = var.description
  session_duration = var.session_duration
  relay_state      = var.relay_state

  tags = var.tags
}

resource "aws_ssoadmin_managed_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  managed_policy_arn = each.value
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline" {
  count = var.inline_policy != null && var.inline_policy != "" ? 1 : 0

  instance_arn       = var.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = var.inline_policy
}
