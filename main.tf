# Security group: single SG with configurable ingress/egress via dynamic blocks. Tags passed by caller.

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = length(ingress.value.cidr_blocks) > 0 ? ingress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) > 0 ? ingress.value.ipv6_cidr_blocks : null
      security_groups  = ingress.value.source_security_group_id != "" ? [ingress.value.source_security_group_id] : null
      self             = ingress.value.self
      description      = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = length(egress.value.cidr_blocks) > 0 ? egress.value.cidr_blocks : null
      ipv6_cidr_blocks = length(egress.value.ipv6_cidr_blocks) > 0 ? egress.value.ipv6_cidr_blocks : null
      security_groups  = egress.value.destination_security_group_id != "" ? [egress.value.destination_security_group_id] : null
      self             = egress.value.self
      description      = egress.value.description
    }
  }

  # Default egress (allow all outbound) when no custom egress rules
  dynamic "egress" {
    for_each = var.create_default_egress && length(var.egress_rules) == 0 ? [1] : []
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }

  tags = var.tags
}
