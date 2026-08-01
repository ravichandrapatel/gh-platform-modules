variable "cluster_id" {
  description = "ID or ARN of the existing ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "task_family" {
  description = "Family name for the task definition (revisions not pinned; service uses latest)"
  type        = string
}

variable "container_name" {
  description = "Container name (used for load balancer and when building container_definitions)"
  type        = string
}

variable "container_image" {
  description = "Docker image (used when container_definitions is null)"
  type        = string
  default     = ""
}

variable "container_port" {
  description = "Container port (used for port mapping and load balancer)"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "CPU units (256, 512, 1024, 2048, 4096)"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory in MB (512, 1024, 2048, etc.)"
  type        = string
  default     = "512"
}

variable "network_mode" {
  description = "Network mode (awsvpc, bridge, host, none)"
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Launch type requirements"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "launch_type" {
  description = "Launch type (FARGATE or EC2)"
  type        = string
  default     = "FARGATE"
}

variable "execution_role_arn" {
  description = "Task execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN"
  type        = string
  default     = null
}

variable "subnets" {
  description = "Subnet IDs for the service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for the service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "ALB target group ARN (optional)"
  type        = string
  default     = null
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "environment_variables" {
  description = "Environment variables for the container (when container_definitions is null)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets (valueFrom) for the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "container_definitions" {
  description = "Full container definitions JSON string. If set, container_image and simple env/secrets are ignored."
  type        = string
  default     = null
}

variable "health_check_path" {
  description = "Health check path for default container definition (e.g. /api/health)"
  type        = string
  default     = "/"
}

variable "health_check_start_period_seconds" {
  description = "Container health check start period: ignore failures for the first N seconds"
  type        = number
  default     = 90
}

variable "log_group_name" {
  description = "CloudWatch log group name (created if not empty)"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 7
}

variable "enable_execute_command" {
  description = "Enable ECS Exec"
  type        = bool
  default     = false
}

variable "enable_deployment_circuit_breaker" {
  description = "If true, enable the ECS deployment circuit breaker (failure detection during deployments)."
  type        = bool
  default     = true
}

variable "deployment_circuit_breaker_rollback" {
  description = "When the circuit breaker is enabled, if true ECS rolls the service back to the last completed deployment after a failed deployment. If false, the failed deployment stops but no automatic rollback occurs."
  type        = bool
  default     = true
}

variable "deployment_failure_sns_topic_arn" {
  description = "Optional SNS topic ARN for EventBridge notifications on ECS SERVICE_DEPLOYMENT_FAILED. Requires enable_deployment_circuit_breaker = true (AWS only emits this event when the deployment circuit breaker is enabled). The topic must allow events.amazonaws.com to sns:Publish (see sns-topic module allow_eventbridge_publish)."
  type        = string
  default     = null

  validation {
    condition = (
      var.deployment_failure_sns_topic_arn == null ||
      var.deployment_failure_sns_topic_arn == "" ||
      var.enable_deployment_circuit_breaker
    )
    error_message = "deployment_failure_sns_topic_arn requires enable_deployment_circuit_breaker = true (SERVICE_DEPLOYMENT_FAILED events require the deployment circuit breaker)."
  }
}

variable "deployment_maximum_percent" {
  description = "Maximum percent of desired tasks allowed running during deployment (reduces rapid task churn on failure)"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum percent of desired tasks that must remain running during deployment"
  type        = number
  default     = 100
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore ELB health checks on new tasks (longer value avoids infrequent task creation when previous task failed)"
  type        = number
  default     = 300
}

variable "push_task_definition_to_service" {
  description = "If true, on apply a local-exec runs 'aws ecs update-service --task-definition ...' so the service uses the Terraform task definition. Use when making serious task-def changes (secrets, resources). Set to true, apply, then set back to false. Requires AWS CLI and credentials."
  type        = bool
  default     = false
}

variable "enable_autoscaling" {
  description = "If true, register ECS service with Application Auto Scaling and add target-tracking policies for average CPU and average memory utilization."
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum ECS service desired count when autoscaling is enabled."
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum ECS service desired count when autoscaling is enabled."
  type        = number
  default     = 10
}

variable "autoscaling_cpu_target_percent" {
  description = "Target average CPU utilization (percent) for the CPU target-tracking policy."
  type        = number
  default     = 70
}

variable "autoscaling_memory_target_percent" {
  description = "Target average memory utilization (percent) for the memory target-tracking policy."
  type        = number
  default     = 80
}

variable "autoscaling_scale_in_cooldown_seconds" {
  description = "Cooldown before another scale-in (seconds)."
  type        = number
  default     = 300
}

variable "autoscaling_scale_out_cooldown_seconds" {
  description = "Cooldown before another scale-out (seconds)."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Tags for task definition, service, and log group"
  type        = map(string)
  default     = {}
}
