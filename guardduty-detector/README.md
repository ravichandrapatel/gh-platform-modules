# guardduty-detector

Single GuardDuty detector for an AWS account and region.

## Example

```hcl
module "guardduty" {
  source = "../../modules/guardduty-detector"

  enable = true
}
```

## Import

Discover the detector ID (UUID, not the AWS account ID):

```bash
aws guardduty list-detectors --region us-east-1 --query 'DetectorIds[0]' --output text
```

```bash
terraform import aws_guardduty_detector.this <detector-id>
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Whether the GuardDuty detector is enabled | `bool` | `true` | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | Finding publishing frequency for the detector (ignored after import if AWS differs) | `string` | `"SIX_HOURS"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the detector (GuardDuty detectors do not support tags in all API versions; reserved for future use) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | AWS account ID associated with the detector |
| <a name="output_detector_arn"></a> [detector\_arn](#output\_detector\_arn) | ARN of the GuardDuty detector |
| <a name="output_detector_id"></a> [detector\_id](#output\_detector\_id) | ID of the GuardDuty detector |
<!-- END_TF_DOCS -->
