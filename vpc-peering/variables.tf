variable "peer_vpc_id" {
  description = "The ID of the VPC with which you are creating the peering connection."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the requester VPC."
  type        = string
}

variable "auto_accept" {
  description = "Accept the peering (both VPCs need to be in the same AWS account)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "requester_route_table_ids" {
  description = "Route table IDs in the requester VPC to add routes to the peer VPC."
  type        = list(string)
  default     = []
}

variable "accepter_route_table_ids" {
  description = "Route table IDs in the accepter VPC to add routes to the requester VPC."
  type        = list(string)
  default     = []
}

variable "peer_cidr_block" {
  description = "The CIDR block of the peer VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the requester VPC."
  type        = string
}

variable "allow_remote_vpc_dns_resolution" {
  description = "Enable private DNS resolution across the peering for both requester and accepter (resolve the peer VPC's private hosted zone names). Requires the peering to be active/auto-accepted."
  type        = bool
  default     = false
}
