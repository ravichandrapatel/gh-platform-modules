output "tags" {
  description = "Merged tags for resource"
  value       = local.tags
}

output "tags_asg" {
  description = "Tags formatted for Auto Scaling Groups"
  value = [
    for key, value in local.tags : {
      key                 = key
      value               = value
      propagate_at_launch = true
    }
  ]
}
