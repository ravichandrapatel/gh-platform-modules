# ECS service: task definition, service, log group, optional Application Auto Scaling (CPU + memory target tracking).

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  # Application Auto Scaling expects the ECS cluster name, not the full ARN.
  cluster_name_for_autoscaling = element(split("/", var.cluster_id), length(split("/", var.cluster_id)) - 1)

  # Matches the service ARN on ECS Deployment State Change events (EventBridge `resources` filter).
  ecs_service_event_arn = "arn:aws:ecs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:service/${local.cluster_name_for_autoscaling}/${var.service_name}"

  deployment_failure_notifications = (
    var.deployment_failure_sns_topic_arn != null &&
    var.deployment_failure_sns_topic_arn != ""
  )

  log_group_name = var.log_group_name != "" ? var.log_group_name : "/ecs/${var.service_name}"
  use_custom_def = var.container_definitions != null

  app_log_config = {
    logDriver = "awslogs"
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.this.name
      "awslogs-region"        = data.aws_region.current.id
      "awslogs-stream-prefix" = "ecs"
    }
  }

  app_container = {
    name      = var.container_name
    image     = var.container_image
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]
    environment      = var.environment_variables
    secrets          = var.secrets
    logConfiguration = local.app_log_config
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}${var.health_check_path} || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = var.health_check_start_period_seconds
    }
  }

  default_containers    = [local.app_container]
  container_definitions = local.use_custom_def ? var.container_definitions : jsonencode(local.default_containers)
}

resource "aws_cloudwatch_log_group" "this" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = local.container_definitions

  tags = var.tags

  lifecycle {
    # CI/CD owns image/env/secrets revisions; aws_ecs_service already ignores task_definition.
    # Without this, secret-list drift forces a new task-def revision on every plan.
    ignore_changes = [container_definitions]
  }
}

# Service uses the task definition from this module at first apply. After that, task_definition is
# ignored so CI/CD can update the service to new revisions without Terraform overwriting it (avoids
# 100+ revisions from CI/CD while Terraform keeps pointing the service at state).
resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn != null ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  enable_execute_command = var.enable_execute_command

  # Deployment circuit breaker: ECS monitors steady-state progress; on failure
  # can stop the deployment and optionally roll back to the previous task def.
  dynamic "deployment_circuit_breaker" {
    for_each = var.enable_deployment_circuit_breaker ? [1] : []
    content {
      enable   = true
      rollback = var.deployment_circuit_breaker_rollback
    }
  }

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  tags = var.tags

  depends_on = [aws_ecs_task_definition.this]

  lifecycle {
    # desired_count: allow scaling outside Terraform (e.g. autoscaling, manual).
    # task_definition: ignore so CI/CD can deploy new revisions; use push_task_definition_to_service when you need to push serious task-def changes.
    ignore_changes = [desired_count, task_definition]
  }
}

# Notify when ECS emits SERVICE_DEPLOYMENT_FAILED (requires deployment circuit breaker; see AWS ECS Deployment State Change events).
resource "aws_cloudwatch_event_rule" "deployment_failure" {
  count = local.deployment_failure_notifications ? 1 : 0

  name_prefix = "${var.service_name}-deploy-failed-"
  description = "ECS deployment failure (circuit breaker) for service ${var.service_name} on cluster ${local.cluster_name_for_autoscaling}"

  event_pattern = jsonencode({
    source      = ["aws.ecs"]
    detail-type = ["ECS Deployment State Change"]
    detail = {
      eventName = ["SERVICE_DEPLOYMENT_FAILED"]
    }
    resources = [local.ecs_service_event_arn]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "deployment_failure_sns" {
  count = local.deployment_failure_notifications ? 1 : 0

  rule      = aws_cloudwatch_event_rule.deployment_failure[0].name
  target_id = "DeploymentFailureSNS"
  arn       = var.deployment_failure_sns_topic_arn

  # Human-readable notification instead of the raw event JSON. The service ARN
  # contains the cluster name (e.g. service/prod-cell01-cluster/rxasset), which
  # identifies the cell that failed.
  input_transformer {
    input_paths = {
      service = "$.resources[0]"
      reason  = "$.detail.reason"
      time    = "$.time"
      region  = "$.region"
    }
    input_template = "\"ECS deployment FAILED: <service> at <time> (<region>). Reason: <reason>. Check the ECS console for rollback status.\""
  }
}

# Application Auto Scaling (ECS service desired count) — optional CPU + memory target tracking.
resource "aws_appautoscaling_target" "ecs" {
  count = var.enable_autoscaling ? 1 : 0

  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${local.cluster_name_for_autoscaling}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.this]
}

resource "aws_appautoscaling_policy" "cpu" {
  count = var.enable_autoscaling ? 1 : 0

  name               = "${var.service_name}-cpu-tt"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.autoscaling_cpu_target_percent
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown_seconds
    scale_out_cooldown = var.autoscaling_scale_out_cooldown_seconds
  }
}

resource "aws_appautoscaling_policy" "memory" {
  count = var.enable_autoscaling ? 1 : 0

  name               = "${var.service_name}-memory-tt"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.autoscaling_memory_target_percent
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown_seconds
    scale_out_cooldown = var.autoscaling_scale_out_cooldown_seconds
  }
}

# Optional: when push_task_definition_to_service = true, update the ECS service to the Terraform task definition (for serious changes).
resource "null_resource" "push_task_definition" {
  count = var.push_task_definition_to_service ? 1 : 0

  triggers = {
    task_definition_arn = aws_ecs_task_definition.this.arn
  }

  provisioner "local-exec" {
    command = "aws ecs update-service --cluster ${var.cluster_id} --service ${var.service_name} --task-definition ${aws_ecs_task_definition.this.arn} --force-new-deployment --region ${data.aws_region.current.id} --no-cli-pager"
  }
}
