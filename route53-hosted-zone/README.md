# Route53 hosted zone

Creates **one** `aws_route53_zone`. With **no** VPC associations the zone is **public**. With **one or more** `vpc` associations the zone is **private** (associated with those VPCs).

For multiple zones (e.g. one public `dev.example.com` and one private copy for split-horizon), call this module once per zone.

## Example (public)

```hcl
module "public_dev" {
  source = "../modules/route53-hosted-zone"

  name    = "dev.example.com"
  comment = "Public dev delegation"
  tags    = { Environment = "dev" }
}
```

## Example (private – split horizon)

```hcl
module "private_dev" {
  source = "../modules/route53-hosted-zone"

  name    = "dev.example.com"
  comment = "Private mirror for VPC resolution"
  vpc_associations = [
    { vpc_id = module.vpc.vpc_id, vpc_region = "us-east-1" }
  ]
  tags = { Environment = "dev" }
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
| <a name="input_comment"></a> [comment](#input\_comment) | Optional comment on the hosted zone. | `string` | `""` | no |
| <a name="input_delegation_set_id"></a> [delegation\_set\_id](#input\_delegation\_set\_id) | Optional reusable delegation set ID (public zones only). Leave empty to omit. | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | If true, deletes all records when destroying the zone (use with care). | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Hosted zone name (FQDN), e.g. dev.example.com. or example.com. Trailing dot optional per provider resolution. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the hosted zone. | `map(string)` | `{}` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | VPC associations for a private hosted zone. Leave empty for a public zone. At least one VPC is required when creating a private zone. | <pre>list(object({<br/>    vpc_id     = string<br/>    vpc_region = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Route 53 hosted zone ARN. |
| <a name="output_name"></a> [name](#output\_name) | Hosted zone name. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | Delegate NS records to these for public zones; empty for private-only usage. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Hosted zone ID (use in aws\_route53\_record.zone\_id). |
<!-- END_TF_DOCS -->
