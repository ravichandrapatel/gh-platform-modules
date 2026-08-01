variable "name" {
  description = "The name of the organizational unit."
  type        = string
}

variable "parent_id" {
  description = "The parent ID of the organizational unit."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
