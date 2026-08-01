# S3 Bucket Notification

Single `aws_s3_bucket_notification` for one bucket, with optional Lambda notification targets and matching `aws_lambda_permission` resources so S3 can invoke those functions.

## Example

```hcl
module "notification" {
  source = "../../modules/s3-bucket-notification"

  bucket = module.bucket.bucket_id

  lambda_notifications = {
    import-trigger = {
      function_arn  = module.import_trigger.arn
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "rxdetect/clean/"
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Name of the S3 bucket to configure notifications on | `string` | n/a | yes |
| <a name="input_eventbridge"></a> [eventbridge](#input\_eventbridge) | Whether to enable EventBridge notifications for the bucket | `bool` | `false` | no |
| <a name="input_lambda_notifications"></a> [lambda\_notifications](#input\_lambda\_notifications) | Map of Lambda notification configurations keyed by stable id | <pre>map(object({<br/>    function_arn  = string<br/>    events        = list(string)<br/>    filter_prefix = optional(string)<br/>    filter_suffix = optional(string)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Bucket the notification is configured on |
| <a name="output_id"></a> [id](#output\_id) | ID of the bucket notification |
<!-- END_TF_DOCS -->
