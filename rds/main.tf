# DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

# Parameter Group
resource "aws_db_parameter_group" "this" {
  count = var.create_parameter_group && length(var.parameters) > 0 ? 1 : 0

  name   = var.parameter_group_name != "" ? var.parameter_group_name : "${var.identifier}-params"
  family = var.parameter_group_family != "" ? var.parameter_group_family : "${var.engine}${floor(tonumber(split(".", var.engine_version)[0]))}"

  dynamic "parameter" {
    for_each = var.parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  tags = var.tags
}

# Option Group
resource "aws_db_option_group" "this" {
  count = var.create_option_group && length(var.options) > 0 ? 1 : 0

  name                     = var.option_group_name != "" ? var.option_group_name : "${var.identifier}-options"
  option_group_description = var.option_group_description != "" ? var.option_group_description : "Option group for ${var.identifier}"
  engine_name              = var.engine
  major_engine_version     = var.major_engine_version != "" ? var.major_engine_version : "${floor(tonumber(split(".", var.engine_version)[0]))}.${split(".", var.engine_version)[1]}"

  dynamic "option" {
    for_each = var.options

    content {
      option_name = option.value.option_name

      dynamic "option_settings" {
        for_each = try(option.value.option_settings, [])

        content {
          name  = option_settings.value.name
          value = option_settings.value.value
        }
      }
    }
  }

  tags = var.tags
}

# RDS Instance
resource "aws_db_instance" "this" {
  identifier = var.identifier

  # Engine configuration
  engine             = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  license_model      = var.license_model
  character_set_name = var.character_set_name
  timezone           = var.timezone

  # Storage configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id
  iops                  = var.iops
  storage_throughput    = var.storage_throughput

  # Database configuration
  db_name  = var.database_name
  username = var.master_username
  port     = var.port

  # Password management
  manage_master_user_password   = var.manage_master_user_password
  password                      = var.manage_master_user_password ? null : var.master_password
  master_user_secret_kms_key_id = var.master_user_secret_kms_key_id

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az
  availability_zone      = var.multi_az ? null : var.availability_zone

  # Parameter and Option groups
  parameter_group_name = var.create_parameter_group && length(var.parameters) > 0 ? aws_db_parameter_group.this[0].name : var.existing_parameter_group_name
  option_group_name    = var.create_option_group && length(var.options) > 0 ? aws_db_option_group.this[0].name : var.existing_option_group_name

  # Backup configuration
  backup_retention_period  = var.backup_retention_period
  backup_window            = var.backup_window
  copy_tags_to_snapshot    = var.copy_tags_to_snapshot
  delete_automated_backups = var.delete_automated_backups

  # Maintenance configuration
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately

  # Snapshot configuration (stable default: no timestamp() to avoid plan churn)
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : (var.final_snapshot_identifier != null ? var.final_snapshot_identifier : "${var.identifier}-final-snapshot")
  snapshot_identifier       = var.snapshot_identifier

  # Deletion protection
  deletion_protection = var.deletion_protection

  # Performance Insights
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id

  # Enhanced Monitoring
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? var.monitoring_role_arn : null

  # CloudWatch Logs
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Domain and IAM
  domain                              = var.domain
  domain_iam_role_name                = var.domain_iam_role_name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  # Replica configuration
  replicate_source_db = var.replicate_source_db

  # Blue/Green deployment
  blue_green_update {
    enabled = var.blue_green_update_enabled
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      password
    ]
  }
}

# Read Replicas
resource "aws_db_instance" "replica" {
  count = var.create_read_replica ? var.read_replica_count : 0

  identifier = "${var.identifier}-replica-${count.index + 1}"

  replicate_source_db = aws_db_instance.this.identifier
  instance_class      = var.replica_instance_class != "" ? var.replica_instance_class : var.instance_class

  # Storage configuration
  storage_type       = var.storage_type
  storage_encrypted  = var.storage_encrypted
  kms_key_id         = var.kms_key_id
  iops               = var.iops
  storage_throughput = var.storage_throughput

  # Network configuration
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = var.publicly_accessible
  availability_zone      = var.multi_az ? null : try(var.replica_availability_zones[count.index], null)

  # Performance Insights
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id

  # Enhanced Monitoring
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? var.monitoring_role_arn : null

  # CloudWatch Logs
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # Maintenance
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately

  # Backup
  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = merge(
    var.tags,
    {
      Name = "${var.identifier}-replica-${count.index + 1}"
      Role = "ReadReplica"
    }
  )
}
