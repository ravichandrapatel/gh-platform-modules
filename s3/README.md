# S3 Bucket Module

Single S3 bucket with optional versioning, encryption, public access block, website hosting, bucket policy, CORS, lifecycle, logging, and replication. Uses the tagging module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Block public ACLs | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Block public bucket policies | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket | `string` | n/a | yes |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | Bucket policy JSON (optional) | `string` | `null` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | CORS rules for the bucket | <pre>list(object({<br/>    allowed_headers = list(string)<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>    expose_headers  = list(string)<br/>    max_age_seconds = number<br/>  }))</pre> | `[]` | no |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Enable server-side encryption | `bool` | `true` | no |
| <a name="input_enable_public_access_block"></a> [enable\_public\_access\_block](#input\_enable\_public\_access\_block) | Create public access block (set false when SCP denies s3:PutBucketPublicAccessBlock) | `bool` | `true` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Enable bucket versioning | `bool` | `true` | no |
| <a name="input_enable_website_hosting"></a> [enable\_website\_hosting](#input\_enable\_website\_hosting) | Enable static website hosting | `bool` | `false` | no |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | Error document for website hosting | `string` | `"error.html"` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Ignore public ACLs | `bool` | `true` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | Index document for website hosting | `string` | `"index.html"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for encryption (if using KMS) | `string` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Lifecycle rules for the bucket | <pre>list(object({<br/>    id      = string<br/>    enabled = bool<br/>    prefix  = string<br/>    transitions = list(object({<br/>      days          = number<br/>      storage_class = string<br/>    }))<br/>    expiration_days = number<br/>  }))</pre> | `[]` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Bucket logging configuration | <pre>object({<br/>    target_bucket = string<br/>    target_prefix = string<br/>  })</pre> | `null` | no |
| <a name="input_object_lock_enabled"></a> [object\_lock\_enabled](#input\_object\_lock\_enabled) | Enable S3 Object Lock | `bool` | `false` | no |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Replication configuration | <pre>object({<br/>    role = string<br/>    rules = list(object({<br/>      id       = string<br/>      status   = string<br/>      priority = number<br/>      destination = object({<br/>        bucket        = string<br/>        storage_class = string<br/>      })<br/>      filter = object({<br/>        prefix = string<br/>      })<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Restrict public bucket policies | `bool` | `true` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | Server-side encryption algorithm (AES256 or aws:kms) | `string` | `"AES256"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the S3 bucket | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | ARN of the S3 bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Domain name of the S3 bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of the S3 bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | Regional domain name of the S3 bucket |
| <a name="output_website_domain"></a> [website\_domain](#output\_website\_domain) | Website domain (if enabled) |
| <a name="output_website_endpoint"></a> [website\_endpoint](#output\_website\_endpoint) | Website endpoint (if enabled) |
<!-- END_TF_DOCS -->
