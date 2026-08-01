# Step Functions

Single AWS Step Functions state machine. Pass the ASL definition as a JSON string via `definition` (stub or production).

## Example

```hcl
module "sfn" {
  source = "../../modules/step-functions"

  name     = "example-state-machine"
  role_arn = module.role.role_arn
  definition = jsonencode({
    StartAt = "Stub"
    States = {
      Stub = {
        Type = "Pass"
        End  = true
      }
    }
  })

  tags = module.tags.tags
}
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
| <a name="input_definition"></a> [definition](#input\_definition) | Amazon States Language (ASL) definition as a JSON string | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Step Functions state machine | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM role ARN for the state machine | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the state machine | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of the state machine (STANDARD or EXPRESS) | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the state machine |
| <a name="output_id"></a> [id](#output\_id) | ID of the state machine |
| <a name="output_name"></a> [name](#output\_name) | Name of the state machine |
| <a name="output_status"></a> [status](#output\_status) | Status of the state machine |
<!-- END_TF_DOCS -->
