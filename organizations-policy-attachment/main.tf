# AWS Organizations Policy Attachment: attach a policy to a target.

resource "aws_organizations_policy_attachment" "this" {
  policy_id = var.policy_id
  target_id = var.target_id
}

variable "policy_id" {
  description = "The ID of the policy to attach."
  type        = string
}

variable "target_id" {
  description = "The ID of the target (Root, OU, or Account) to attach the policy to."
  type        = string
}
