# Account Assignment Module (Single Resource)

Creates **one** IAM Identity Center (AWS SSO) account assignment: one principal (group or user) + one permission set + one target account.

**Convention:** Use the **same name** for the Identity Center group and the permission set; create the group with the identitystore-group module and pass its `group_id` as `principal_id` here.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_arn"></a> [instance\_arn](#input\_instance\_arn) | ARN of the IAM Identity Center (SSO) instance. | `string` | n/a | yes |
| <a name="input_permission_set_arn"></a> [permission\_set\_arn](#input\_permission\_set\_arn) | ARN of the permission set to assign. | `string` | n/a | yes |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | When principal\_type = 'GROUP': Identity Store group ID (GUID), e.g. module.identitystore\_group.group\_id. When 'USER': Identity Store user ID (GUID). | `string` | n/a | yes |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | Type of principal: GROUP or USER. | `string` | n/a | yes |
| <a name="input_target_id"></a> [target\_id](#input\_target\_id) | Target AWS account ID (12 digits). | `string` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Target type (default AWS\_ACCOUNT). | `string` | `"AWS_ACCOUNT"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assignment_id"></a> [assignment\_id](#output\_assignment\_id) | Composite ID of the account assignment. |
| <a name="output_permission_set_arn"></a> [permission\_set\_arn](#output\_permission\_set\_arn) | Permission set ARN that was assigned. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | Principal ID (Identity Store group or user). |
| <a name="output_principal_type"></a> [principal\_type](#output\_principal\_type) | Principal type (GROUP or USER). |
| <a name="output_target_id"></a> [target\_id](#output\_target\_id) | Target account ID. |
<!-- END_TF_DOCS -->

## Example (with identitystore-group and permission-set)

```hcl
module "account_assignment" {
  source   = "../../modules/account-assignment"
  for_each = toset(["123456789012"])

  instance_arn       = local.instance_arn
  permission_set_arn = module.permission_set.permission_set_arn
  principal_type    = "GROUP"
  principal_id      = module.identitystore_group.group_id
  target_id         = each.value
}
```
