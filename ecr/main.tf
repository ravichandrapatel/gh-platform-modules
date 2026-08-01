# ECR repository: single repository with image scanning, encryption, optional lifecycle policy. Tags passed by caller.

resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key_arn
  }

  tags = var.tags
}

# Default lifecycle policy
locals {
  default_lifecycle_policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 30 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 30
      }
      action = {
        type = "expire"
      }
    }]
  })
}

# Apply lifecycle policy (only when a policy is provided or default is enabled)
resource "aws_ecr_lifecycle_policy" "this" {
  count = (var.lifecycle_policy != "" || var.enable_default_lifecycle_policy) ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = var.lifecycle_policy != "" ? var.lifecycle_policy : local.default_lifecycle_policy
}
