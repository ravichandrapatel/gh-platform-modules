# Lambda

Single AWS Lambda function. When `filename` is unset, a stub Python package is built in-module so infrastructure can be applied before application code is ready.

## Example

```hcl
module "lambda" {
  source = "../../modules/lambda"

  function_name = "example-function"
  role_arn      = module.role.role_arn
  runtime       = "python3.12"
  handler       = "handler.handler"

  tags = module.tags.tags
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture | `list(string)` | <pre>[<br/>  "x86_64"<br/>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda function | `string` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables | `map(string)` | `{}` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to deployment package zip. If null, a stub Python package is built in-module. | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda handler (e.g. handler.handler) | `string` | `"handler.handler"` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda layer ARNs | `list(string)` | `[]` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB | `number` | `128` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as a new Lambda version | `bool` | `false` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Reserved concurrent executions (-1 for unreserved) | `number` | `-1` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM role ARN for the Lambda function | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda runtime (e.g. python3.12, nodejs20.x) | `string` | `"python3.12"` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | Base64-encoded SHA256 hash of the package. Computed automatically for stub packages; set when providing filename. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Lambda function | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Function timeout in seconds | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the Lambda function |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | Invoke ARN of the Lambda function |
| <a name="output_name"></a> [name](#output\_name) | Name of the Lambda function |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | Qualified ARN of the Lambda function (version) |
| <a name="output_version"></a> [version](#output\_version) | Latest published version of the Lambda function |
<!-- END_TF_DOCS -->
