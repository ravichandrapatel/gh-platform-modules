# EC2 instance: single instance for jump/tunnel workloads with optional IAM instance profile.

locals {
  # Standard: al2023-ami-2023.x.x-kernel-*-arm64 | Minimal: al2023-ami-minimal-2023.x.x-kernel-*-arm64
  ami_name_pattern = var.ami_variant == "minimal" ? "al2023-ami-minimal-2023.*-kernel-*-${var.architecture}" : "al2023-ami-2023.*-kernel-*-${var.architecture}"
}

data "aws_ami" "amazon_linux_2023" {
  count = var.ami_id == null ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [local.ami_name_pattern]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux_2023[0].id
}

resource "aws_instance" "this" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  user_data                   = var.user_data

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size           = var.root_volume_size_gb
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  volume_tags = merge(
    var.tags,
    {
      Name = "${var.name}-root"
    }
  )
}
