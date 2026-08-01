# ecs-service

By default, **deployment failure detection** (`deployment_circuit_breaker`) and **automatic rollback** are enabled. When `deployment_failure_sns_topic_arn` is set, EventBridge forwards **`SERVICE_DEPLOYMENT_FAILED`** (emitted when the circuit breaker trips) to SNS. That covers deployments that never become healthy, including bad task definitions, task/secret pull failures, and app or load-balancer health check failures, per the [ECS Deployment State Change](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_service_deployment_events.html) event.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Assign public IP to tasks | `bool` | `false` | no |
| <a name="input_autoscaling_cpu_target_percent"></a> [autoscaling\_cpu\_target\_percent](#input\_autoscaling\_cpu\_target\_percent) | Target average CPU utilization (percent) for the CPU target-tracking policy. | `number` | `70` | no |
| <a name="input_autoscaling_max_capacity"></a> [autoscaling\_max\_capacity](#input\_autoscaling\_max\_capacity) | Maximum ECS service desired count when autoscaling is enabled. | `number` | `10` | no |
| <a name="input_autoscaling_memory_target_percent"></a> [autoscaling\_memory\_target\_percent](#input\_autoscaling\_memory\_target\_percent) | Target average memory utilization (percent) for the memory target-tracking policy. | `number` | `80` | no |
| <a name="input_autoscaling_min_capacity"></a> [autoscaling\_min\_capacity](#input\_autoscaling\_min\_capacity) | Minimum ECS service desired count when autoscaling is enabled. | `number` | `1` | no |
| <a name="input_autoscaling_scale_in_cooldown_seconds"></a> [autoscaling\_scale\_in\_cooldown\_seconds](#input\_autoscaling\_scale\_in\_cooldown\_seconds) | Cooldown before another scale-in (seconds). | `number` | `300` | no |
| <a name="input_autoscaling_scale_out_cooldown_seconds"></a> [autoscaling\_scale\_out\_cooldown\_seconds](#input\_autoscaling\_scale\_out\_cooldown\_seconds) | Cooldown before another scale-out (seconds). | `number` | `60` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | ID or ARN of the existing ECS cluster | `string` | n/a | yes |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Full container definitions JSON string. If set, container\_image and simple env/secrets are ignored. | `string` | `null` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Docker image (used when container\_definitions is null) | `string` | `""` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Container name (used for load balancer and when building container\_definitions) | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container port (used for port mapping and load balancer) | `number` | `80` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units (256, 512, 1024, 2048, 4096) | `string` | `"256"` | no |
| <a name="input_deployment_circuit_breaker_rollback"></a> [deployment\_circuit\_breaker\_rollback](#input\_deployment\_circuit\_breaker\_rollback) | When the circuit breaker is enabled, if true ECS rolls the service back to the last completed deployment after a failed deployment. If false, the failed deployment stops but no automatic rollback occurs. | `bool` | `true` | no |
| <a name="input_deployment_failure_sns_topic_arn"></a> [deployment\_failure\_sns\_topic\_arn](#input\_deployment\_failure\_sns\_topic\_arn) | Optional SNS topic ARN for EventBridge notifications on ECS SERVICE\_DEPLOYMENT\_FAILED. Requires enable\_deployment\_circuit\_breaker = true (AWS only emits this event when the deployment circuit breaker is enabled). The topic must allow events.amazonaws.com to sns:Publish (see sns-topic module allow\_eventbridge\_publish). | `string` | `null` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | Maximum percent of desired tasks allowed running during deployment (reduces rapid task churn on failure) | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | Minimum percent of desired tasks that must remain running during deployment | `number` | `100` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | Desired number of tasks | `number` | `1` | no |
| <a name="input_enable_autoscaling"></a> [enable\_autoscaling](#input\_enable\_autoscaling) | If true, register ECS service with Application Auto Scaling and add target-tracking policies for average CPU and average memory utilization. | `bool` | `false` | no |
| <a name="input_enable_deployment_circuit_breaker"></a> [enable\_deployment\_circuit\_breaker](#input\_enable\_deployment\_circuit\_breaker) | If true, enable the ECS deployment circuit breaker (failure detection during deployments). | `bool` | `true` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Enable ECS Exec | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables for the container (when container\_definitions is null) | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | Task execution role ARN | `string` | n/a | yes |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Seconds to ignore ELB health checks on new tasks (longer value avoids infrequent task creation when previous task failed) | `number` | `300` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health check path for default container definition (e.g. /api/health) | `string` | `"/"` | no |
| <a name="input_health_check_start_period_seconds"></a> [health\_check\_start\_period\_seconds](#input\_health\_check\_start\_period\_seconds) | Container health check start period: ignore failures for the first N seconds | `number` | `90` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | Launch type (FARGATE or EC2) | `string` | `"FARGATE"` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | CloudWatch log group name (created if not empty) | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Log retention in days | `number` | `7` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory in MB (512, 1024, 2048, etc.) | `string` | `"512"` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Network mode (awsvpc, bridge, host, none) | `string` | `"awsvpc"` | no |
| <a name="input_push_task_definition_to_service"></a> [push\_task\_definition\_to\_service](#input\_push\_task\_definition\_to\_service) | If true, on apply a local-exec runs 'aws ecs update-service --task-definition ...' so the service uses the Terraform task definition. Use when making serious task-def changes (secrets, resources). Set to true, apply, then set back to false. Requires AWS CLI and credentials. | `bool` | `false` | no |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | Launch type requirements | `list(string)` | <pre>[<br/>  "FARGATE"<br/>]</pre> | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secrets (valueFrom) for the container | <pre>list(object({<br/>    name      = string<br/>    valueFrom = string<br/>  }))</pre> | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs for the service | `list(string)` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the ECS service | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet IDs for the service | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for task definition, service, and log group | `map(string)` | `{}` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | ALB target group ARN (optional) | `string` | `null` | no |
| <a name="input_task_family"></a> [task\_family](#input\_task\_family) | Family name for the task definition (revisions not pinned; service uses latest) | `string` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | Task role ARN | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_target_resource_id"></a> [autoscaling\_target\_resource\_id](#output\_autoscaling\_target\_resource\_id) | Application Auto Scaling resource\_id (service/clusterName/serviceName) when enable\_autoscaling is true. |
| <a name="output_deployment_circuit_breaker_enabled"></a> [deployment\_circuit\_breaker\_enabled](#output\_deployment\_circuit\_breaker\_enabled) | Whether the ECS deployment circuit breaker is enabled on this service. |
| <a name="output_deployment_circuit_breaker_rollback"></a> [deployment\_circuit\_breaker\_rollback](#output\_deployment\_circuit\_breaker\_rollback) | Whether automatic rollback is enabled when the deployment circuit breaker trips (false if the breaker is disabled). |
| <a name="output_deployment_failure_event_rule_arn"></a> [deployment\_failure\_event\_rule\_arn](#output\_deployment\_failure\_event\_rule\_arn) | EventBridge rule ARN for ECS deployment failure → SNS (null if deployment\_failure\_sns\_topic\_arn is not set). |
| <a name="output_deployment_failure_sns_topic_arn"></a> [deployment\_failure\_sns\_topic\_arn](#output\_deployment\_failure\_sns\_topic\_arn) | SNS topic ARN used for deployment failure notifications (echo of input when configured). |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | CloudWatch log group name |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ECS service ID |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | ECS service name |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | Task definition ARN (service uses this; revisions not pinned in config) |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | Task definition family |
<!-- END_TF_DOCS -->