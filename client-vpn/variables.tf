variable "name" {
  description = "Name of the Client VPN endpoint"
  type        = string
}

variable "client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range must be at least a /22 and must not be greater than a /12."
  type        = string
}

variable "server_certificate_arn" {
  description = "The ARN of the server certificate. For more information, see the AWS Certificate Manager User Guide."
  type        = string
}

variable "authentication_options" {
  description = "Information about the authentication method to be used to authenticate clients."
  type = list(object({
    type                           = string
    active_directory_id            = optional(string)
    root_certificate_chain_arn     = optional(string)
    saml_provider_arn              = optional(string)
    self_service_saml_provider_arn = optional(string)
  }))
}

variable "connection_log_options" {
  description = "Information about the client connection logging options."
  type = object({
    enabled               = bool
    cloudwatch_log_group  = optional(string)
    cloudwatch_log_stream = optional(string)
  })
}

variable "dns_servers" {
  description = "Information about the DNS servers to be used for DNS resolution. A Client VPN endpoint can have up to two DNS servers."
  type        = list(string)
  default     = null
}

variable "transport_protocol" {
  description = "The transport protocol to be used by the VPN session."
  type        = string
  default     = "udp"
  validation {
    condition     = contains(["tcp", "udp"], var.transport_protocol)
    error_message = "Transport protocol must be either tcp or udp."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the Client VPN endpoint."
  type        = string
}

variable "subnet_ids" {
  description = "A list of IDs of the subnets to associate with the Client VPN endpoint."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of IDs of the security groups to apply to the target network."
  type        = list(string)
  default     = []
}

variable "authorization_rules" {
  description = "A list of authorization rules to add to the Client VPN endpoint."
  type = list(object({
    target_network_cidr  = string
    access_group_id      = optional(string)
    authorize_all_groups = optional(bool)
    description          = optional(string)
  }))
  default = []
}

variable "routes" {
  description = "A list of routes to add to the Client VPN endpoint."
  type = list(object({
    destination_cidr_block = string
    target_vpc_subnet_id   = string
    description            = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "split_tunnel" {
  description = "Indicates whether split-tunnel is enabled on the Client VPN endpoint."
  type        = bool
  default     = true
}

variable "self_service_portal" {
  description = "Indicates whether the self-service portal is enabled. Valid values are enabled and disabled."
  type        = string
  default     = "disabled"
  validation {
    condition     = contains(["enabled", "disabled"], var.self_service_portal)
    error_message = "self_service_portal must be either enabled or disabled."
  }
}
