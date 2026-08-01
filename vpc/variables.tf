variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "public_subnets" {
  description = "List of public subnet configurations"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = []
}

variable "public_subnets_map_public_ip_on_launch" {
  description = "Whether to assign public IP on launch for public subnets (set false to match existing state and avoid in-place update)"
  type        = bool
  default     = false
}

variable "public_subnet_default_routes" {
  description = "Optional per-public-subnet default route: \"igw\" (Internet Gateway) or \"nat\" (first zonal NAT Gateway). Must be the same length as public_subnets when set. When null, all public subnets share one route table to the IGW (legacy behavior)."
  type        = list(string)
  default     = null
}

variable "private_subnets" {
  description = "List of private subnet configurations"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
  default = []
}

variable "create_internet_gateway" {
  description = "Create an Internet Gateway for the VPC"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Create NAT Gateway(s) for private subnets"
  type        = bool
  default     = false
}

variable "nat_gateway_per_az" {
  description = "Create one NAT Gateway per AZ (true) or single NAT Gateway (false)"
  type        = bool
  default     = false
}

variable "nat_gateway_subnets" {
  description = "Indices of public subnets to place NAT Gateways in (empty = use first subnet). Ignored when nat_gateway_availability_mode is regional."
  type        = list(number)
  default     = []
}

variable "nat_gateway_availability_mode" {
  description = "NAT Gateway mode: zonal (per-AZ or single in a subnet) or regional (single VPC-level NAT, multi-AZ). Regional does not require public subnets for the NAT."
  type        = string
  default     = "zonal"
  validation {
    condition     = contains(["zonal", "regional"], var.nat_gateway_availability_mode)
    error_message = "nat_gateway_availability_mode must be zonal or regional."
  }
}

variable "enable_vpn_gateway" {
  description = "Create a VPN Gateway"
  type        = bool
  default     = false
}

variable "vpn_gateway_asn" {
  description = "ASN for the VPN Gateway"
  type        = number
  default     = null
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_logs_destination_type" {
  description = "Type of flow logs destination (cloud-watch-logs or s3)"
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_logs_retention_days" {
  description = "CloudWatch log retention in days for flow logs"
  type        = number
  default     = 7
}

variable "flow_logs_traffic_type" {
  description = "Type of traffic to capture (ACCEPT, REJECT, ALL)"
  type        = string
  default     = "ALL"
}

variable "vpc_endpoints" {
  description = "Map of VPC endpoints to create. For Gateway type, use route_table_scope = [\"private\", \"public\"]. For Interface type, use subnet_scope = [\"private\"] to use this module's subnets; leave security_group_ids empty to use the module-created endpoints SG."
  type = map(object({
    service_name        = string
    vpc_endpoint_type   = string # Interface or Gateway
    subnet_ids          = optional(list(string), [])
    security_group_ids  = optional(list(string), [])
    private_dns_enabled = optional(bool, true)
    route_table_ids     = optional(list(string), [])
    route_table_scope   = optional(list(string), []) # \"private\" and/or \"public\" — use this module's route tables (Gateway only)
    subnet_scope        = optional(list(string), []) # \"private\" and/or \"public\" — use this module's subnets (Interface only)
  }))
  default = {}
}

variable "additional_tags" {
  description = "Additional tags for VPC resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to VPC and all created resources"
  type        = map(string)
  default     = {}
}
