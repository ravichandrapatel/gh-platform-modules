variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name."
}

variable "force_destroy" {
  type        = bool
  description = "Allow bucket delete even if objects remain. Keep false outside throwaway envs."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the bucket."
  default     = {}
}
