<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_service_access_principals"></a> [aws\_service\_access\_principals](#input\_aws\_service\_access\_principals) | List of AWS service principal names for which you want to enable integration with your organization. | `list(string)` | `[]` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | List of Organizations policy types to enable in the Organization Root. | `list(string)` | `[]` | no |
| <a name="input_feature_set"></a> [feature\_set](#input\_feature\_set) | The feature set of the organization. One of ALL or CONSOLIDATED\_BILLING. | `string` | `"ALL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the organization |
| <a name="output_id"></a> [id](#output\_id) | Identifier of the organization |
| <a name="output_master_account_arn"></a> [master\_account\_arn](#output\_master\_account\_arn) | ARN of the master account |
| <a name="output_master_account_id"></a> [master\_account\_id](#output\_master\_account\_id) | Identifier of the master account |
| <a name="output_roots"></a> [roots](#output\_roots) | List of organization roots |
<!-- END_TF_DOCS -->