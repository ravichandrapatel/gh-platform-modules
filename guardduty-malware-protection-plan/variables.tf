variable "bucket_name" {
  description = "Name of the S3 bucket to protect with GuardDuty malware scanning"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role GuardDuty uses to scan objects and apply tags in the bucket"
  type        = string
}

variable "object_prefixes" {
  description = "S3 object key prefixes to scan. Empty list scans all objects in the bucket."
  type        = list(string)
  default     = []
}

variable "enable_object_tagging" {
  description = "When true, GuardDuty adds GuardDutyMalwareScanStatus tags to scanned objects"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the malware protection plan"
  type        = map(string)
  default     = {}
}
