# Tagging Module

No AWS resources. Exposes a `tags` map (Environment, CostCenter, Owner, Project, Tier) for use by **caller/root** configurations. Validates environment (PROD, NON-PROD, ACPT) and tier (frontend, middleware, database).

**Usage:** Use this module in your root or composition layer (e.g. `terraform/examples/tagging-caller-example/`), then pass `tags = module.tags.tags` (or merge with extra keys) into resource modules (ALB, ECS, VPC, S3, security-group, RDS, ACM, ECR, CloudFront, secrets-manager). Resource modules accept `variable "tags"` and do not instantiate the tagging module themselves.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center tag value | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (allowed values: PROD, NON-PROD, ACPT) | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner tag value | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_resource"></a> [resource](#input\_resource) | AWS resource type or logical name for the Resource tag (e.g. vpc, ecs, s3, ecr, acm, alb) | `string` | `""` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | Tier tag value (allowed: frontend, middleware, database) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | Merged tags for resource |
| <a name="output_tags_asg"></a> [tags\_asg](#output\_tags\_asg) | Tags formatted for Auto Scaling Groups |
<!-- END_TF_DOCS -->
