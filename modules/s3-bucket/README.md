# s3-bucket

Private, encrypted, versioned S3 bucket with public access blocked.

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| bucket_name | yes | — | Globally unique name |
| force_destroy | no | false | Allow non-empty delete |
| tags | no | {} | Resource tags |

## Outputs

| Name | Description |
| --- | --- |
| bucket_id | Bucket name |
| bucket_arn | Bucket ARN |
