# GuardDuty detector: single regional detector (account-level threat detection).

resource "aws_guardduty_detector" "this" {
  enable = var.enable

  finding_publishing_frequency = var.finding_publishing_frequency

  lifecycle {
    ignore_changes = [
      datasources,
      finding_publishing_frequency,
    ]
  }
}
