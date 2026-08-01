# Route53 Module

Looks up an **existing** public hosted zone and creates **multiple** records via `for_each`. To **create** zones or **multiple records in one map** for a known `zone_id`, use **`route53-hosted-zone`** and **`route53-record`** instead.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The hosted zone domain name (e.g. example.com.). Used to lookup the Route53 zone. | `string` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | A map of records to create. Supports both standard and alias records. | <pre>map(object({<br/>    name            = string<br/>    type            = string<br/>    ttl             = optional(number)<br/>    records         = optional(list(string))<br/>    allow_overwrite = optional(bool)<br/>    alias = optional(object({<br/>      name                   = string<br/>      zone_id                = string<br/>      evaluate_target_health = optional(bool)<br/>    }))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_fqdns"></a> [record\_fqdns](#output\_record\_fqdns) | Map of record keys to FQDNs for the created records |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Hosted Zone ID used for the records |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | The name of the Hosted Zone |
<!-- END_TF_DOCS -->
