# Secrets Manager Module

Single secret with optional version, rotation, and replica regions. Uses the tagging module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_placeholder_version"></a> [create\_placeholder\_version](#input\_create\_placeholder\_version) | If no secret\_string or secret\_key\_value is provided, create an initial version with a dummy value (e.g. {}). Keys are taken from Terraform; values are preserved from AWS when the key exists (console/rotation updates kept). Removing a key in Terraform removes it from the secret. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the secret | `string` | `""` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for encryption | `string` | `null` | no |
| <a name="input_preserve_existing_secret_values"></a> [preserve\_existing\_secret\_values](#input\_preserve\_existing\_secret\_values) | If true, read the current secret value from AWS and preserve existing values for keys that already exist (console/rotation changes win). If false, do not read from AWS; the secret is fully controlled by Terraform (use when the secret has no current version yet or to avoid 'couldn't find resource' errors). | `bool` | `true` | no |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | Recovery window in days (0 for immediate deletion) | `number` | `30` | no |
| <a name="input_replica_regions"></a> [replica\_regions](#input\_replica\_regions) | Regions to replicate the secret to | <pre>list(object({<br/>    region     = string<br/>    kms_key_id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_rotation_days"></a> [rotation\_days](#input\_rotation\_days) | Number of days between automatic rotations | `number` | `30` | no |
| <a name="input_rotation_enabled"></a> [rotation\_enabled](#input\_rotation\_enabled) | Enable automatic rotation | `bool` | `false` | no |
| <a name="input_rotation_lambda_arn"></a> [rotation\_lambda\_arn](#input\_rotation\_lambda\_arn) | ARN of Lambda function for rotation | `string` | `""` | no |
| <a name="input_secret_key_value"></a> [secret\_key\_value](#input\_secret\_key\_value) | Map of key-value pairs for the secret (alternative to secret\_string) | `map(string)` | `{}` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name of the secret | `string` | n/a | yes |
| <a name="input_secret_string"></a> [secret\_string](#input\_secret\_string) | Secret string value (JSON format recommended) | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the secret | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | ID of the secret |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret |
| <a name="output_secret_version_id"></a> [secret\_version\_id](#output\_secret\_version\_id) | Version ID of the secret |
<!-- END_TF_DOCS -->
