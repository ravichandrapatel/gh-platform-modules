# Identity Store Group Module (Single Resource)

Creates **one** group in IAM Identity Center (AWS Identity Store). Use with the permission-set and account-assignment modules. **Convention:** use the same name for the group and the permission set (e.g. `display_name = "Developers"` and permission set `name = "Developers"`).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the group. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the group. Typically use the same name as the permission set (e.g. 'Developers'). | `string` | n/a | yes |
| <a name="input_identity_store_id"></a> [identity\_store\_id](#input\_identity\_store\_id) | Identity Store ID (from the IAM Identity Center instance). Use e.g. tolist(data.aws\_ssoadmin\_instances.main.identity\_store\_ids)[0]. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | Display name of the group. |
| <a name="output_external_ids"></a> [external\_ids](#output\_external\_ids) | External IDs of the group (if any). |
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | Identity Store group ID (GUID). Use as principal\_id in account-assignment when principal\_type = 'GROUP'. |
<!-- END_TF_DOCS -->

## Example: single group (same name as permission set)

```hcl
data "aws_ssoadmin_instances" "main" {}
locals {
  instance_arn      = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}

module "developers_group" {
  source = "../../modules/identitystore-group"
  identity_store_id = local.identity_store_id
  display_name      = "Developers"
  description       = "Developers group"
}
```

## Example: multiple groups (for_each)

```hcl
module "identitystore_group" {
  source   = "../../modules/identitystore-group"
  for_each = local.groups
  identity_store_id = local.identity_store_id
  display_name      = each.value.display_name
  description       = try(each.value.description, null)
}
```
