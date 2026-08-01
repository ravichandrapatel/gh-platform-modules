# Route53 records

Creates **one or more** `aws_route53_record` resources in **one** hosted zone. Pass a **`records`** map: each key is a stable Terraform identifier, each value is one record (name, type, and either `records` for simple types or `alias` for ALB/CloudFront/etc.).

Use **one** stack file to manage many DNS names: either Terraform **`records`**, or Terragrunt **`records_json`** (recommended when `dependency.*` cannot be nested under `inputs`).

For **creating** the zone, use **`route53-hosted-zone`**.

## Terragrunt: `records_json` + `format` / `jsonencode`

Build JSON so each `dependency.foo.outputs.bar` appears only as a **top-level** argument (e.g. to `jsonencode()` or `format()`), not inside a nested HCL object:

```hcl
inputs = {
  zone_id = dependency.zone.outputs.zone_id
  records_json = format(
    "{\"api_dev\":{\"name\":\"api\",\"type\":\"A\",\"alias\":{\"name\":%s,\"zone_id\":%s,\"evaluate_target_health\":true}}}",
    jsonencode(dependency.alb.outputs.alb_dns_name),
    jsonencode(dependency.alb.outputs.alb_zone_id)
  )
}
```

Do not set **`records`** and **`records_json`** with content at the same time.

## Example (two records)

```hcl
module "private_records" {
  source = "../modules/route53-record"

  zone_id = module.private_dev.zone_id

  records = {
    api_dev = {
      name = "api"
      type = "A"
      alias = {
        name                   = aws_lb.this.dns_name
        zone_id                = aws_lb.this.zone_id
        evaluate_target_health = true
      }
    }
    someservice = {
      name    = "svc"
      type    = "CNAME"
      ttl     = 300
      records = ["target.example.com"]
    }
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
| <a name="input_records"></a> [records](#input\_records) | Map of logical keys (stable identifiers) to record definitions. Ignored when records\_json is non-null. | <pre>map(object({<br/>    name            = string<br/>    type            = string<br/>    ttl             = optional(number, 300)<br/>    records         = optional(list(string))<br/>    allow_overwrite = optional(bool)<br/>    alias = optional(object({<br/>      name                   = string<br/>      zone_id                = string<br/>      evaluate_target_health = optional(bool)<br/>    }))<br/>    health_check_id = optional(string)<br/>    set_identifier  = optional(string)<br/>    weighted_routing_policy = optional(object({<br/>      weight = number<br/>    }))<br/>    failover_routing_policy = optional(object({<br/>      type = string<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_records_json"></a> [records\_json](#input\_records\_json) | JSON document with the same structure as var.records (object maps). Use from Terragrunt when dependency outputs cannot be nested in an HCL object (build JSON with format/jsonencode on dependency values only). | `string` | `null` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | ID of the hosted zone (aws\_route53\_zone.this.zone\_id or data source). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdns"></a> [fqdns](#output\_fqdns) | Map of record keys to FQDNs. |
| <a name="output_names"></a> [names](#output\_names) | Map of record keys to expanded record names. |
| <a name="output_types"></a> [types](#output\_types) | Map of record keys to DNS types. |
<!-- END_TF_DOCS -->
