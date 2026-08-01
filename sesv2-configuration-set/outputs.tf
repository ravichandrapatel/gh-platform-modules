output "arn" {
  description = "SESv2 configuration set ARN"
  value       = aws_sesv2_configuration_set.this.arn
}

output "configuration_set_name" {
  description = "SESv2 configuration set name"
  value       = aws_sesv2_configuration_set.this.configuration_set_name
}
