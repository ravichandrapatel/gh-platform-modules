resource "random_id" "suffix" {
  byte_length = 4
}

module "topic" {
  source = "../../../../sns-topic"

  name                      = "floci-sns-${random_id.suffix.hex}"
  allow_eventbridge_publish = true
  tags = {
    Environment = "test"
    Project     = "floci"
    ManagedBy   = "opentofu"
  }
}

output "topic_arn" {
  value = module.topic.arn
}
