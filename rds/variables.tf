variable "identifier" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "Instance class"
  type        = string
}

variable "license_model" {
  description = "License model"
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "Character set name"
  type        = string
  default     = null
}

variable "timezone" {
  description = "Timezone"
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum allocated storage"
  type        = number
  default     = null
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
}

variable "iops" {
  description = "IOPS"
  type        = number
  default     = null
}

variable "storage_throughput" {
  description = "Storage throughput"
  type        = number
  default     = null
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID"
  type        = string
  default     = null
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "master_username" {
  description = "Master username"
  type        = string
}

variable "manage_master_user_password" {
  description = "Use Secrets Manager"
  type        = bool
  default     = true
}

variable "master_password" {
  description = "Master password"
  type        = string
  default     = null
  sensitive   = true
}

variable "master_user_secret_kms_key_id" {
  description = "KMS key for secret"
  type        = string
  default     = null
}

variable "port" {
  description = "Database port"
  type        = number
  default     = null
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = null
}

variable "publicly_accessible" {
  description = "Publicly accessible"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Multi-AZ"
  type        = bool
  default     = false
}

variable "create_parameter_group" {
  description = "Create parameter group"
  type        = bool
  default     = false
}

variable "parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = ""
}

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = ""
}

variable "existing_parameter_group_name" {
  description = "Existing parameter group"
  type        = string
  default     = null
}

variable "parameters" {
  description = "Parameters"
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = []
}

variable "create_option_group" {
  description = "Create option group"
  type        = bool
  default     = false
}

variable "option_group_name" {
  description = "Option group name"
  type        = string
  default     = ""
}

variable "option_group_description" {
  description = "Option group description"
  type        = string
  default     = ""
}

variable "major_engine_version" {
  description = "Major engine version"
  type        = string
  default     = ""
}

variable "existing_option_group_name" {
  description = "Existing option group"
  type        = string
  default     = null
}

variable "options" {
  description = "Options"
  type = list(object({
    option_name = string
    option_settings = list(object({
      name  = string
      value = string
    }))
  }))
  default = []
}

variable "backup_retention_period" {
  description = "Backup retention period"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "copy_tags_to_snapshot" {
  description = "Copy tags to snapshot"
  type        = bool
  default     = true
}

variable "delete_automated_backups" {
  description = "Delete automated backups"
  type        = bool
  default     = true
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "auto_minor_version_upgrade" {
  description = "Auto minor version upgrade"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply immediately"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier"
  type        = string
  default     = null
}

variable "snapshot_identifier" {
  description = "Snapshot identifier"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Deletion protection"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Performance Insights"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention"
  type        = number
  default     = 7
}

variable "performance_insights_kms_key_id" {
  description = "Performance Insights KMS key"
  type        = string
  default     = null
}

variable "monitoring_interval" {
  description = "Monitoring interval"
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "Monitoring role ARN"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "CloudWatch log exports"
  type        = list(string)
  default     = []
}

variable "domain" {
  description = "Domain"
  type        = string
  default     = null
}

variable "domain_iam_role_name" {
  description = "Domain IAM role"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "IAM database authentication"
  type        = bool
  default     = false
}

variable "replicate_source_db" {
  description = "Replicate source DB"
  type        = string
  default     = null
}

variable "blue_green_update_enabled" {
  description = "Blue/green deployment"
  type        = bool
  default     = false
}

variable "create_read_replica" {
  description = "Create read replica"
  type        = bool
  default     = false
}

variable "read_replica_count" {
  description = "Read replica count"
  type        = number
  default     = 0
}

variable "replica_instance_class" {
  description = "Replica instance class"
  type        = string
  default     = ""
}

variable "replica_availability_zones" {
  description = "Replica availability zones"
  type        = list(string)
  default     = []
}

variable "additional_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to RDS resources"
  type        = map(string)
  default     = {}
}
