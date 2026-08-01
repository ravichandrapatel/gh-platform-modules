locals {
  tags = merge(
    {
      Environment = var.environment
      CostCenter  = var.cost_center
      Owner       = var.owner
      Project     = var.project
      Tier        = var.tier
    },
    var.resource != "" ? { Resource = var.resource } : {}
  )
}
