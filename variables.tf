variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights. Set to false for default CloudWatch monitoring only (no Container Insights)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the cluster"
  type        = map(string)
  default     = {}
}
