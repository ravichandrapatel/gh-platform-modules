# EventBridge Scheduler

Single Amazon EventBridge Scheduler schedule targeting an ARN (Step Functions, Lambda, etc.).

## Example

```hcl
module "schedule" {
  source = "../../modules/eventbridge-scheduler"

  name                = "example-hourly"
  schedule_expression = "rate(1 hour)"
  target_arn          = module.sfn.arn
  role_arn            = module.scheduler_role.role_arn
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
| <a name="input_description"></a> [description](#input\_description) | Description of the schedule | `string` | `null` | no |
| <a name="input_flexible_time_window_mode"></a> [flexible\_time\_window\_mode](#input\_flexible\_time\_window\_mode) | Flexible time window mode (OFF or FLEXIBLE) | `string` | `"OFF"` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | Name of the schedule group | `string` | `"default"` | no |
| <a name="input_input"></a> [input](#input\_input) | Optional JSON input passed to the target | `string` | `null` | no |
| <a name="input_maximum_window_in_minutes"></a> [maximum\_window\_in\_minutes](#input\_maximum\_window\_in\_minutes) | Maximum flexible window in minutes (required when mode is FLEXIBLE) | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the EventBridge Scheduler schedule | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM role ARN that EventBridge Scheduler assumes to invoke the target | `string` | n/a | yes |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | Schedule expression (e.g. rate(1 hour), cron(...)) | `string` | n/a | yes |
| <a name="input_schedule_expression_timezone"></a> [schedule\_expression\_timezone](#input\_schedule\_expression\_timezone) | Timezone for the schedule expression | `string` | `null` | no |
| <a name="input_state"></a> [state](#input\_state) | Whether the schedule is ENABLED or DISABLED | `string` | `"ENABLED"` | no |
| <a name="input_target_arn"></a> [target\_arn](#input\_target\_arn) | ARN of the schedule target (e.g. Step Functions state machine) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the schedule |
| <a name="output_id"></a> [id](#output\_id) | ID of the schedule |
| <a name="output_name"></a> [name](#output\_name) | Name of the schedule |
<!-- END_TF_DOCS -->
