variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = ""
}

variable "secret_string" {
  description = "Secret string value (JSON format recommended)"
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_key_value" {
  description = "Map of key-value pairs for the secret (alternative to secret_string)"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "preserve_existing_secret_values" {
  description = "If true, read the current secret value from AWS and preserve existing values for keys that already exist (console/rotation changes win). If false, do not read from AWS; the secret is fully controlled by Terraform (use when the secret has no current version yet or to avoid 'couldn't find resource' errors)."
  type        = bool
  default     = true
}

variable "create_placeholder_version" {
  description = "If no secret_string or secret_key_value is provided, create an initial version with a dummy value (e.g. {}). Keys are taken from Terraform; values are preserved from AWS when the key exists (console/rotation updates kept). Removing a key in Terraform removes it from the secret."
  type        = bool
  default     = false
}

variable "recovery_window_in_days" {
  description = "Recovery window in days (0 for immediate deletion)"
  type        = number
  default     = 30
}

variable "rotation_enabled" {
  description = "Enable automatic rotation"
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "ARN of Lambda function for rotation"
  type        = string
  default     = ""
}

variable "rotation_days" {
  description = "Number of days between automatic rotations"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "replica_regions" {
  description = "Regions to replicate the secret to"
  type = list(object({
    region     = string
    kms_key_id = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the secret"
  type        = map(string)
  default     = {}
}
