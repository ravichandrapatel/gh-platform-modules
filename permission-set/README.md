# Permission Set Module (Single Resource)

Creates **one** IAM Identity Center (AWS SSO) permission set with **dynamic** managed policy attachments and an optional inline policy.

**Convention:** Use the **same name** for the permission set and the Identity Center group (e.g. `name = "Developers"` here and `display_name = "Developers"` in the identitystore-group module).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the permission set. | `string` | `null` | no |
| <a name="input_inline_policy"></a> [inline\_policy](#input\_inline\_policy) | JSON policy document for inline policy (at most one per permission set in AWS). | `string` | `null` | no |
| <a name="input_instance_arn"></a> [instance\_arn](#input\_instance\_arn) | ARN of the IAM Identity Center (SSO) instance. | `string` | n/a | yes |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | List of AWS managed policy ARNs to attach (dynamic attachment). | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the permission set. Typically use the same name as the Identity Center group (e.g. 'Developers'). | `string` | n/a | yes |
| <a name="input_relay_state"></a> [relay\_state](#input\_relay\_state) | URL for federation redirect (optional). | `string` | `null` | no |
| <a name="input_session_duration"></a> [session\_duration](#input\_session\_duration) | Session duration (e.g. PT1H, PT8H, PT12H). | `string` | `"PT1H"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the permission set. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of the permission set. |
| <a name="output_permission_set_arn"></a> [permission\_set\_arn](#output\_permission\_set\_arn) | ARN of the permission set. |
| <a name="output_permission_set_id"></a> [permission\_set\_id](#output\_permission\_set\_id) | ID of the permission set. |
<!-- END_TF_DOCS -->

## Example

```hcl
data "aws_ssoadmin_instances" "main" {}
locals { instance_arn = tolist(data.aws_ssoadmin_instances.main.arns)[0] }

module "developers_ps" {
  source = "../../modules/permission-set"
  instance_arn = local.instance_arn
  name         = "Developers"
  description  = "Developers permission set"
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  tags = { Name = "Developers" }
}
```
