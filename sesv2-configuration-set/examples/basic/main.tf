# Basic example: SESv2 configuration set.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "sesv2_configuration_set" {
  source = "../.."

  configuration_set_name = "example-config-set"
  sending_options = {
    sending_enabled = true
  }
}

output "configuration_set_arn" {
  value = module.sesv2_configuration_set.arn
}
