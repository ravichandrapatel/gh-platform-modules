# AWS Client VPN Module

This module creates an AWS Client VPN endpoint, network associations, authorization rules, and routes.

## Usage

```hcl
module "client_vpn" {
  source = "../../modules/client-vpn"

  name                   = "prod-vpn"
  client_cidr_block      = "10.100.0.0/22"
  server_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/..."
  vpc_id                 = "vpc-12345678"
  subnet_ids             = ["subnet-12345678"]
  
  authentication_options = [{
    type = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:us-east-1:123456789012:certificate/..."
  }]

  connection_log_options = {
    enabled = false
  }
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
| <a name="input_authentication_options"></a> [authentication\_options](#input\_authentication\_options) | Information about the authentication method to be used to authenticate clients. | <pre>list(object({<br/>    type                           = string<br/>    active_directory_id            = optional(string)<br/>    root_certificate_chain_arn     = optional(string)<br/>    saml_provider_arn              = optional(string)<br/>    self_service_saml_provider_arn = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_authorization_rules"></a> [authorization\_rules](#input\_authorization\_rules) | A list of authorization rules to add to the Client VPN endpoint. | <pre>list(object({<br/>    target_network_cidr  = string<br/>    access_group_id      = optional(string)<br/>    authorize_all_groups = optional(bool)<br/>    description          = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_client_cidr_block"></a> [client\_cidr\_block](#input\_client\_cidr\_block) | The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range must be at least a /22 and must not be greater than a /12. | `string` | n/a | yes |
| <a name="input_connection_log_options"></a> [connection\_log\_options](#input\_connection\_log\_options) | Information about the client connection logging options. | <pre>object({<br/>    enabled               = bool<br/>    cloudwatch_log_group  = optional(string)<br/>    cloudwatch_log_stream = optional(string)<br/>  })</pre> | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Information about the DNS servers to be used for DNS resolution. A Client VPN endpoint can have up to two DNS servers. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Client VPN endpoint | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | A list of routes to add to the Client VPN endpoint. | <pre>list(object({<br/>    destination_cidr_block = string<br/>    target_vpc_subnet_id   = string<br/>    description            = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of IDs of the security groups to apply to the target network. | `list(string)` | `[]` | no |
| <a name="input_self_service_portal"></a> [self\_service\_portal](#input\_self\_service\_portal) | Indicates whether the self-service portal is enabled. Valid values are enabled and disabled. | `string` | `"disabled"` | no |
| <a name="input_server_certificate_arn"></a> [server\_certificate\_arn](#input\_server\_certificate\_arn) | The ARN of the server certificate. For more information, see the AWS Certificate Manager User Guide. | `string` | n/a | yes |
| <a name="input_split_tunnel"></a> [split\_tunnel](#input\_split\_tunnel) | Indicates whether split-tunnel is enabled on the Client VPN endpoint. | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of IDs of the subnets to associate with the Client VPN endpoint. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_transport_protocol"></a> [transport\_protocol](#input\_transport\_protocol) | The transport protocol to be used by the VPN session. | `string` | `"udp"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to associate with the Client VPN endpoint. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the Client VPN endpoint. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | The DNS name of the Client VPN endpoint. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Client VPN endpoint. |
<!-- END_TF_DOCS -->
