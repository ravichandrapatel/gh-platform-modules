# Account assignment: single Identity Center assignment (principal + permission set + target account).

resource "aws_ssoadmin_account_assignment" "this" {
  instance_arn       = var.instance_arn
  permission_set_arn = var.permission_set_arn
  principal_type     = var.principal_type
  principal_id       = var.principal_id
  target_id          = var.target_id
  target_type        = var.target_type
}
