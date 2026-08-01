# Route53 ACM DNS validation

Creates Route 53 records from ACM `domain_validation_options` and `aws_acm_certificate_validation` so the certificate reaches `ISSUED`.

## Usage

Caller supplies an **existing** public hosted zone ID and the certificate’s `domain_validation_options` (and ARN). The hosted zone must already be delegated in the parent zone so ACM can resolve the validation CNAMEs.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of aws\_acm\_certificate to validate (same region as the certificate, typically us-east-1 for CloudFront). | `string` | n/a | yes |
| <a name="input_domain_validation_options"></a> [domain\_validation\_options](#input\_domain\_validation\_options) | ACM domain\_validation\_options from the certificate (pass aws\_acm\_certificate.this[0].domain\_validation\_options). | <pre>list(object({<br/>    domain_name           = string<br/>    resource_record_name  = string<br/>    resource_record_type  = string<br/>    resource_record_value = string<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources that support them (validation waiter has no tags; reserved for future use). | `map(string)` | `{}` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route 53 hosted zone ID (public zone that is authoritative for the ACM validation record names). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | ARN of the validated ACM certificate (ISSUED). |
| <a name="output_validation_record_fqdns"></a> [validation\_record\_fqdns](#output\_validation\_record\_fqdns) | FQDNs of the Route 53 validation records created. |
<!-- END_TF_DOCS -->
