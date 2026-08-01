# Application Load Balancer Module

ALB with one default target group, HTTP listener (forward or redirect to HTTPS), optional HTTPS listener, optional **additional target groups**, and optional **listener rules** (path or host-based routing). Create the ALB with this module and pass `target_group_arn` or `target_group_arns["key"]` to the ECS module. Tags passed by caller.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ARN of ACM certificate for HTTPS listener | `string` | `""` | no |
| <a name="input_additional_target_groups"></a> [additional\_target\_groups](#input\_additional\_target\_groups) | Additional target groups (key = logical name for use in listener\_rules and outputs). Default target group is always created; use this for extra TGs (e.g. api, web). | <pre>map(object({<br/>    port                  = number<br/>    protocol              = optional(string, "HTTP")<br/>    target_type           = optional(string, "ip")<br/>    health_check_path     = optional(string, "/")<br/>    health_check_interval = optional(number, 30)<br/>    health_check_timeout  = optional(number, 5)<br/>    healthy_threshold     = optional(number, 2)<br/>    unhealthy_threshold   = optional(number, 2)<br/>    deregistration_delay  = optional(number, 30)<br/>    matcher               = optional(string, "200-299")<br/>  }))</pre> | `{}` | no |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | Deregistration delay in seconds | `number` | `30` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Enable cross-zone load balancing | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Enable deletion protection | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Enable HTTP/2 | `bool` | `true` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | Health check interval in seconds | `number` | `30` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Path for health checks | `string` | `"/"` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | Health check timeout in seconds | `number` | `5` | no |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | Number of consecutive successful health checks | `number` | `2` | no |
| <a name="input_http_default_action"></a> [http\_default\_action](#input\_http\_default\_action) | HTTP (80) listener default action when ACM cert is set: redirect\_to\_https (all to HTTPS) or fixed\_response\_404 (default 404, use http\_redirect\_hosts for redirect rules) | `string` | `"redirect_to_https"` | no |
| <a name="input_http_redirect_hosts"></a> [http\_redirect\_hosts](#input\_http\_redirect\_hosts) | Host headers to redirect to HTTPS (only when http\_default\_action = fixed\_response\_404). Each gets a listener rule with redirect to 443. | `list(string)` | `[]` | no |
| <a name="input_https_default_action"></a> [https\_default\_action](#input\_https\_default\_action) | HTTPS (443) listener default action: forward (to default target group) or fixed\_response\_404 | `string` | `"forward"` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | Idle timeout in seconds | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Whether the load balancer is internal | `bool` | `false` | no |
| <a name="input_listener_rules"></a> [listener\_rules](#input\_listener\_rules) | Additional listener rules (path or host-based routing). target\_group\_key = 'default' for the default TG, or a key from additional\_target\_groups. Specify listener\_port 80 or 443. | <pre>list(object({<br/>    listener_port    = number<br/>    priority         = number<br/>    path_pattern     = optional(string)<br/>    host_header      = optional(string)<br/>    target_group_key = string<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ALB | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the ALB | `list(string)` | n/a | yes |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL policy for HTTPS listener | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs for the ALB | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to ALB resources | `map(string)` | `{}` | no |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | Port on which targets receive traffic | `number` | `80` | no |
| <a name="input_target_protocol"></a> [target\_protocol](#input\_target\_protocol) | Protocol to use for routing traffic to targets | `string` | `"HTTP"` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Type of target (instance, ip, lambda) | `string` | `"ip"` | no |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | Number of consecutive failed health checks | `number` | `2` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the ALB will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the ALB |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS name of the ALB |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | Zone ID of the ALB |
| <a name="output_http_listener_arn"></a> [http\_listener\_arn](#output\_http\_listener\_arn) | ARN of the HTTP listener |
| <a name="output_https_listener_arn"></a> [https\_listener\_arn](#output\_https\_listener\_arn) | ARN of the HTTPS listener |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | ARN of the default target group (backward compatible) |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | Map of target group ARNs: 'default' = default TG, plus keys from additional\_target\_groups. Pass to ECS or other services. |
| <a name="output_target_group_name"></a> [target\_group\_name](#output\_target\_group\_name) | Name of the default target group |
<!-- END_TF_DOCS -->
