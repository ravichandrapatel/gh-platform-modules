output "bucket" {
  description = "Bucket the notification is configured on"
  value       = aws_s3_bucket_notification.this.bucket
}

output "id" {
  description = "ID of the bucket notification"
  value       = aws_s3_bucket_notification.this.id
}
