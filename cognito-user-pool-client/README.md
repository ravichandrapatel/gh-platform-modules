# Cognito User Pool Client Module

Single Cognito user pool app client with optional OAuth and token settings.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_token_validity"></a> [access\_token\_validity](#input\_access\_token\_validity) | Access token validity in minutes | `number` | `60` | no |
| <a name="input_allowed_oauth_flows"></a> [allowed\_oauth\_flows](#input\_allowed\_oauth\_flows) | Allowed OAuth flows | `list(string)` | `[]` | no |
| <a name="input_allowed_oauth_flows_user_pool_client"></a> [allowed\_oauth\_flows\_user\_pool\_client](#input\_allowed\_oauth\_flows\_user\_pool\_client) | Whether OAuth flows are enabled for the app client | `bool` | `false` | no |
| <a name="input_allowed_oauth_scopes"></a> [allowed\_oauth\_scopes](#input\_allowed\_oauth\_scopes) | Allowed OAuth scopes | `list(string)` | `[]` | no |
| <a name="input_callback_urls"></a> [callback\_urls](#input\_callback\_urls) | OAuth callback URLs | `list(string)` | `[]` | no |
| <a name="input_enable_token_revocation"></a> [enable\_token\_revocation](#input\_enable\_token\_revocation) | Enable token revocation | `bool` | `true` | no |
| <a name="input_explicit_auth_flows"></a> [explicit\_auth\_flows](#input\_explicit\_auth\_flows) | Explicit authentication flows | `list(string)` | `[]` | no |
| <a name="input_generate_secret"></a> [generate\_secret](#input\_generate\_secret) | Generate a client secret | `bool` | `false` | no |
| <a name="input_id_token_validity"></a> [id\_token\_validity](#input\_id\_token\_validity) | ID token validity in minutes | `number` | `60` | no |
| <a name="input_logout_urls"></a> [logout\_urls](#input\_logout\_urls) | OAuth logout URLs | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Cognito user pool client name | `string` | n/a | yes |
| <a name="input_prevent_user_existence_errors"></a> [prevent\_user\_existence\_errors](#input\_prevent\_user\_existence\_errors) | Prevent user existence errors mode | `string` | `"ENABLED"` | no |
| <a name="input_read_attributes"></a> [read\_attributes](#input\_read\_attributes) | Readable attributes | `list(string)` | `[]` | no |
| <a name="input_refresh_token_validity"></a> [refresh\_token\_validity](#input\_refresh\_token\_validity) | Refresh token validity in days | `number` | `30` | no |
| <a name="input_supported_identity_providers"></a> [supported\_identity\_providers](#input\_supported\_identity\_providers) | Supported identity providers | `list(string)` | <pre>[<br/>  "COGNITO"<br/>]</pre> | no |
| <a name="input_user_pool_id"></a> [user\_pool\_id](#input\_user\_pool\_id) | Cognito user pool ID | `string` | n/a | yes |
| <a name="input_write_attributes"></a> [write\_attributes](#input\_write\_attributes) | Writable attributes | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | Cognito user pool client ID |
| <a name="output_client_secret"></a> [client\_secret](#output\_client\_secret) | Cognito user pool client secret (if generated) |
| <a name="output_id"></a> [id](#output\_id) | Cognito user pool client ID |
| <a name="output_name"></a> [name](#output\_name) | Cognito user pool client name |
<!-- END_TF_DOCS -->
