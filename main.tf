# Route53 hosted zone: single public or private zone; private zones require at least one VPC association.

resource "aws_route53_zone" "this" {
  name          = var.name
  comment       = var.comment != "" ? var.comment : null
  force_destroy = var.force_destroy

  dynamic "vpc" {
    for_each = var.vpc_associations
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = try(vpc.value.vpc_region, null)
    }
  }

  delegation_set_id = var.delegation_set_id != "" ? var.delegation_set_id : null

  tags = var.tags
}
