variable "floci_endpoint" {
  type        = string
  description = "Floci AWS emulator base URL."
  default     = "http://localhost:4566"
}

provider "aws" {
  region     = "us-east-1"
  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
  s3_use_path_style           = true

  endpoints {
    apigateway       = var.floci_endpoint
    cloudformation   = var.floci_endpoint
    cloudwatch       = var.floci_endpoint
    dynamodb         = var.floci_endpoint
    ec2              = var.floci_endpoint
    ecr              = var.floci_endpoint
    ecs              = var.floci_endpoint
    elasticache      = var.floci_endpoint
    elasticbeanstalk = var.floci_endpoint
    elb              = var.floci_endpoint
    emr              = var.floci_endpoint
    es               = var.floci_endpoint
    firehose         = var.floci_endpoint
    glacier          = var.floci_endpoint
    iam              = var.floci_endpoint
    kinesis          = var.floci_endpoint
    kms              = var.floci_endpoint
    lambda           = var.floci_endpoint
    logs             = var.floci_endpoint
    rds              = var.floci_endpoint
    redshift         = var.floci_endpoint
    route53          = var.floci_endpoint
    s3               = var.floci_endpoint
    secretsmanager   = var.floci_endpoint
    ses              = var.floci_endpoint
    sns              = var.floci_endpoint
    sqs              = var.floci_endpoint
    ssm              = var.floci_endpoint
    stepfunctions    = var.floci_endpoint
    sts              = var.floci_endpoint
  }
}
