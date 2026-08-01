# IAM role: single role with optional assume role policy, managed/custom/inline policies, optional instance profile.

resource "aws_iam_role" "this" {
  name                 = var.role_name
  assume_role_policy   = var.assume_role_policy != null ? var.assume_role_policy : data.aws_iam_policy_document.assume_role[0].json
  description          = var.description
  max_session_duration = var.max_session_duration
  path                 = var.path
  permissions_boundary = var.permissions_boundary

  dynamic "inline_policy" {
    for_each = var.inline_policies
    content {
      name   = inline_policy.value.name
      policy = inline_policy.value.policy
    }
  }

  tags = var.tags
}

# Default assume role policy document if not provided
data "aws_iam_policy_document" "assume_role" {
  count = var.assume_role_policy == null ? 1 : 0

  dynamic "statement" {
    for_each = var.trusted_entities
    content {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = statement.value.type
        identifiers = statement.value.identifiers
      }

      dynamic "condition" {
        for_each = lookup(statement.value, "conditions", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

# Attach AWS managed policies
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# Create and attach custom policies
resource "aws_iam_policy" "custom" {
  for_each = var.custom_policies

  name        = each.value.name
  description = lookup(each.value, "description", null)
  path        = lookup(each.value, "path", "/")
  policy      = each.value.policy

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "custom_policies" {
  for_each = var.custom_policies

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom[each.key].arn
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = var.instance_profile_name != null ? var.instance_profile_name : var.role_name
  role = aws_iam_role.this.name
  path = var.path

  tags = var.tags
}
