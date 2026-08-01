variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Idle timeout in seconds"
  type        = number
  default     = 60
}

variable "target_port" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Protocol to use for routing traffic to targets"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Type of target (instance, ip, lambda)"
  type        = string
  default     = "ip"
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks"
  type        = number
  default     = 2
}

variable "deregistration_delay" {
  description = "Deregistration delay in seconds"
  type        = number
  default     = 30
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for HTTPS listener"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "http_default_action" {
  description = "HTTP (80) listener default action when ACM cert is set: redirect_to_https (all to HTTPS) or fixed_response_404 (default 404, use http_redirect_hosts for redirect rules)"
  type        = string
  default     = "redirect_to_https"
  validation {
    condition     = contains(["redirect_to_https", "fixed_response_404"], var.http_default_action)
    error_message = "http_default_action must be redirect_to_https or fixed_response_404."
  }
}

variable "http_redirect_hosts" {
  description = "Host headers to redirect to HTTPS (only when http_default_action = fixed_response_404). Each gets a listener rule with redirect to 443."
  type        = list(string)
  default     = []
}

variable "https_default_action" {
  description = "HTTPS (443) listener default action: forward (to default target group) or fixed_response_404"
  type        = string
  default     = "forward"
  validation {
    condition     = contains(["forward", "fixed_response_404"], var.https_default_action)
    error_message = "https_default_action must be forward or fixed_response_404."
  }
}

variable "additional_target_groups" {
  description = "Additional target groups (key = logical name for use in listener_rules and outputs). Default target group is always created; use this for extra TGs (e.g. api, web)."
  type = map(object({
    port                  = number
    protocol              = optional(string, "HTTP")
    target_type           = optional(string, "ip")
    health_check_path     = optional(string, "/")
    health_check_interval = optional(number, 30)
    health_check_timeout  = optional(number, 5)
    healthy_threshold     = optional(number, 2)
    unhealthy_threshold   = optional(number, 2)
    deregistration_delay  = optional(number, 30)
    matcher               = optional(string, "200-299")
  }))
  default = {}
}

variable "listener_rules" {
  description = "Additional listener rules (path or host-based routing). target_group_key = 'default' for the default TG, or a key from additional_target_groups. Specify listener_port 80 or 443."
  type = list(object({
    listener_port    = number
    priority         = number
    path_pattern     = optional(string)
    host_header      = optional(string)
    target_group_key = string
  }))
  default = []
  validation {
    condition = alltrue([
      for r in var.listener_rules : (r.path_pattern != null && r.path_pattern != "") || (r.host_header != null && r.host_header != "")
    ])
    error_message = "Each listener rule must have either path_pattern or host_header set."
  }
  validation {
    condition = alltrue([
      for r in var.listener_rules : r.listener_port == 80 || r.listener_port == 443
    ])
    error_message = "listener_port must be 80 or 443."
  }
  validation {
    condition = alltrue([
      for r in var.listener_rules : r.target_group_key == "default" || contains(keys(var.additional_target_groups), r.target_group_key)
    ])
    error_message = "target_group_key must be 'default' or a key from additional_target_groups."
  }
}

variable "tags" {
  description = "Tags to apply to ALB resources"
  type        = map(string)
  default     = {}
}
