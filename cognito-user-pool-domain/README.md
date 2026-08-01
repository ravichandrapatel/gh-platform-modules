# Cognito User Pool Domain Module

Single Cognito user pool domain binding with optional custom-domain ACM certificate.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ACM certificate ARN for a custom domain (optional) | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Cognito user pool domain prefix or custom domain | `string` | n/a | yes |
| <a name="input_user_pool_id"></a> [user\_pool\_id](#input\_user\_pool\_id) | Cognito user pool ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution"></a> [cloudfront\_distribution](#output\_cloudfront\_distribution) | CloudFront distribution DNS name for custom domains |
| <a name="output_domain"></a> [domain](#output\_domain) | Configured Cognito domain |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | S3 bucket where managed login assets are hosted |
<!-- END_TF_DOCS -->
