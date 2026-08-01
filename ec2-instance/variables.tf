variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the instance. When null, resolves the latest Amazon Linux 2023 AMI for ami_variant and architecture."
  type        = string
  default     = null
}

variable "ami_variant" {
  description = "Amazon Linux 2023 AMI variant when ami_id is null: standard (full OS) or minimal."
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "minimal"], var.ami_variant)
    error_message = "ami_variant must be standard or minimal."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the instance is launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for the instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH access"
  type        = string
  default     = null
}

variable "user_data" {
  description = "Optional user data script (plain text)"
  type        = string
  default     = null
}

variable "architecture" {
  description = "CPU architecture used when resolving the default Amazon Linux 2023 AMI (arm64 or x86_64)"
  type        = string
  default     = "arm64"
  validation {
    condition     = contains(["arm64", "x86_64"], var.architecture)
    error_message = "architecture must be arm64 or x86_64."
  }
}

variable "root_volume_size_gb" {
  description = "Root EBS volume size in GiB. Amazon Linux 2023 AMIs require at least 30 GiB (AMI root snapshot size)."
  type        = number
  default     = 30
  validation {
    condition     = var.root_volume_size_gb >= 30 && var.root_volume_size_gb <= 16384
    error_message = "root_volume_size_gb must be between 30 and 16384 (AL2023 AMI minimum is 30 GiB)."
  }
}

variable "tags" {
  description = "Tags to apply to the EC2 instance and root volume"
  type        = map(string)
  default     = {}
}
