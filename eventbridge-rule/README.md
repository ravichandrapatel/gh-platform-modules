# EventBridge rule

Single **Amazon EventBridge** (`aws_cloudwatch_event_rule`) with an optional **SNS** target. Keep `event_pattern` generic at the module boundary; callers encode ECS, EC2, or other sources.

**ECS deployment failures:** pass a pattern that matches `source = ["aws.ecs"]` and `detail-type = ["ECS Service Action"]`, and filter on `detail.eventName` / `detail.clusterArn` as needed. See [ECS service action events](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-service-action-events.html).

Pair with [`sns-topic`](../sns-topic): set `allow_eventbridge_publish = true` on the topic, then set `target_sns_topic_arn = module.sns_topic.arn` here.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the rule. | `string` | `null` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | Event pattern JSON string. Use jsonencode({ ... }) at the caller. Example for ECS: source aws.ecs, detail-type ECS Service Action, detail.eventName / clusterArn filters — see AWS docs. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the EventBridge rule. | `string` | n/a | yes |
| <a name="input_state"></a> [state](#input\_state) | Whether the rule is enabled (ENABLED) or disabled (DISABLED). | `string` | `"ENABLED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the EventBridge rule. | `map(string)` | `{}` | no |
| <a name="input_target_id"></a> [target\_id](#input\_target\_id) | Unique target identifier within the rule. | `string` | `"SNS"` | no |
| <a name="input_target_sns_topic_arn"></a> [target\_sns\_topic\_arn](#input\_target\_sns\_topic\_arn) | If set, send matching events to this SNS topic ARN. The topic policy must allow events.amazonaws.com to publish (use sns-topic module allow\_eventbridge\_publish). | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rule_arn"></a> [rule\_arn](#output\_rule\_arn) | ARN of the EventBridge rule. |
| <a name="output_rule_id"></a> [rule\_id](#output\_rule\_id) | ID of the EventBridge rule. |
| <a name="output_rule_name"></a> [rule\_name](#output\_rule\_name) | Name of the EventBridge rule. |
<!-- END_TF_DOCS -->
