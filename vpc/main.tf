# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(var.tags, { Name = var.vpc_name })
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  count = var.create_internet_gateway && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.vpc_name}-igw" })
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index].cidr_block
  availability_zone       = var.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.public_subnets_map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      Name = var.public_subnets[count.index].name
      Type = "Public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index].cidr_block
  availability_zone       = var.private_subnets[count.index].availability_zone
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = var.private_subnets[count.index].name
      Type = "Private"
    }
  )
}

# Elastic IPs for NAT Gateways
locals {
  nat_gateway_subnets = length(var.nat_gateway_subnets) > 0 ? var.nat_gateway_subnets : [0]
  use_regional_nat    = var.create_nat_gateway && var.nat_gateway_availability_mode == "regional" && length(var.private_subnets) > 0
  use_zonal_nat       = var.create_nat_gateway && var.nat_gateway_availability_mode == "zonal" && var.create_internet_gateway && length(var.public_subnets) > 0
  zonal_nat_count     = local.use_zonal_nat ? (var.nat_gateway_per_az ? length(var.private_subnets) : 1) : 0
  nat_gateway_count   = local.use_regional_nat ? 1 : local.zonal_nat_count

  use_split_public_routing = var.public_subnet_default_routes != null
  public_split_needs_igw   = local.use_split_public_routing && contains(var.public_subnet_default_routes, "igw")
  public_split_needs_nat   = local.use_split_public_routing && contains(var.public_subnet_default_routes, "nat")
}

check "public_subnet_default_routes_length" {
  assert {
    condition = var.public_subnet_default_routes == null || (
      length(var.public_subnet_default_routes) == length(var.public_subnets)
    )
    error_message = "public_subnet_default_routes must be null or have the same length as public_subnets."
  }
}

check "public_subnet_default_routes_values" {
  assert {
    condition = var.public_subnet_default_routes == null || alltrue([
      for r in var.public_subnet_default_routes : contains(["igw", "nat"], r)
    ])
    error_message = "Each public_subnet_default_routes entry must be \"igw\" or \"nat\"."
  }
}

check "public_nat_requires_gateway" {
  assert {
    condition = !local.use_split_public_routing || !local.public_split_needs_nat || (
      var.create_nat_gateway && local.nat_gateway_count > 0
    )
    error_message = "Public subnets with default route \"nat\" require create_nat_gateway and a deployed NAT Gateway (e.g. zonal mode with nat in a public subnet)."
  }
}

resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    }
  )
}

# NAT Gateways: regional (VPC-level, one NAT) or zonal (per subnet/AZ)
resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id

  # Regional NAT: VPC-level, no subnet; scales across AZs automatically
  vpc_id            = local.use_regional_nat ? aws_vpc.this.id : null
  availability_mode = local.use_regional_nat ? "regional" : null

  # Zonal NAT: in a public subnet
  subnet_id = local.use_zonal_nat ? aws_subnet.public[var.nat_gateway_per_az ? count.index : local.nat_gateway_subnets[0]].id : null

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-${count.index + 1}"
    }
  )
}

# Public route tables: legacy single IGW table, or split IGW vs NAT (e.g. shared non-prod Acpt public egress via NAT).
resource "aws_route_table" "public" {
  count = !local.use_split_public_routing && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-rt"
      Type = "Public"
    }
  )
}

resource "aws_route_table" "public_igw" {
  count = local.use_split_public_routing && local.public_split_needs_igw ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-rt-igw"
      Type = "Public"
    }
  )
}

resource "aws_route_table" "public_nat" {
  count = local.use_split_public_routing && local.public_split_needs_nat ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-rt-nat"
      Type = "Public"
    }
  )
}

# Public Route to Internet Gateway (legacy single table)
resource "aws_route" "public_internet" {
  count = var.create_internet_gateway && !local.use_split_public_routing && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route" "public_igw_internet" {
  count = var.create_internet_gateway && local.use_split_public_routing && local.public_split_needs_igw ? 1 : 0

  route_table_id         = aws_route_table.public_igw[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

# Public subnets using NAT use the first zonal NAT Gateway (same as single-NAT private routing).
resource "aws_route" "public_nat_default" {
  count = local.use_split_public_routing && local.public_split_needs_nat && local.nat_gateway_count > 0 ? 1 : 0

  route_table_id         = aws_route_table.public_nat[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = local.use_split_public_routing ? (
    var.public_subnet_default_routes[count.index] == "igw" ? aws_route_table.public_igw[0].id : aws_route_table.public_nat[0].id
  ) : aws_route_table.public[0].id
}

# Private Route Tables: one for regional NAT, or per-AZ/single for zonal NAT
locals {
  private_route_table_count = length(var.private_subnets) > 0 && local.nat_gateway_count > 0 ? (local.use_regional_nat ? 1 : (var.nat_gateway_per_az ? length(var.private_subnets) : 1)) : 0
}

resource "aws_route_table" "private" {
  count = local.private_route_table_count

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-private-rt-${count.index + 1}"
      Type = "Private"
    }
  )
}

# Private Route to NAT Gateway (only when NAT gateways exist). Count from variables so import/plan works without full state.
resource "aws_route" "private_nat" {
  count = local.nat_gateway_count > 0 ? local.private_route_table_count : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = (local.use_regional_nat || !var.nat_gateway_per_az) ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = (local.use_regional_nat || !var.nat_gateway_per_az) ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}

# VPN Gateway
resource "aws_vpn_gateway" "this" {
  count = var.enable_vpn_gateway ? 1 : 0

  vpc_id          = aws_vpc.this.id
  amazon_side_asn = var.vpn_gateway_asn

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-vpn-gw"
    }
  )
}

# VPC Flow Logs
resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs" ? 1 : 0

  name              = "/aws/vpc/flowlogs/${var.vpc_name}"
  retention_in_days = var.flow_logs_retention_days

  tags = var.tags
}

resource "aws_iam_role" "flow_logs" {
  count = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs" ? 1 : 0

  name = "${var.vpc_name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "flow_logs" {
  count = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs" ? 1 : 0

  name = "${var.vpc_name}-flow-logs-policy"
  role = aws_iam_role.flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "this" {
  count = var.enable_flow_logs ? 1 : 0

  vpc_id          = aws_vpc.this.id
  traffic_type    = var.flow_logs_traffic_type
  iam_role_arn    = var.flow_logs_destination_type == "cloud-watch-logs" ? aws_iam_role.flow_logs[0].arn : null
  log_destination = var.flow_logs_destination_type == "cloud-watch-logs" ? aws_cloudwatch_log_group.flow_logs[0].arn : null

  tags = var.tags
}

# VPC Endpoints: resolve route_table_scope (Gateway) and subnet_scope (Interface); optional SG for Interface
locals {
  public_route_table_ids_for_gateway = local.use_split_public_routing ? concat(
    aws_route_table.public_igw[*].id,
    aws_route_table.public_nat[*].id,
  ) : aws_route_table.public[*].id

  gateway_endpoint_route_table_ids = {
    for k, v in var.vpc_endpoints : k => flatten([
      for scope in try(v.route_table_scope, []) :
      scope == "private" ? (length(aws_route_table.private) > 0 ? aws_route_table.private[*].id : []) : (scope == "public" ? (length(local.public_route_table_ids_for_gateway) > 0 ? local.public_route_table_ids_for_gateway : []) : [])
    ]) if v.vpc_endpoint_type == "Gateway" && length(try(v.route_table_scope, [])) > 0
  }
  endpoint_route_table_ids = {
    for k, v in var.vpc_endpoints : k => v.vpc_endpoint_type == "Gateway" ? (try(local.gateway_endpoint_route_table_ids[k], null) != null ? local.gateway_endpoint_route_table_ids[k] : v.route_table_ids) : null
  }
  # Interface endpoints: resolve subnet_scope to subnet IDs; use module subnets when scope is set
  interface_endpoint_subnet_ids = {
    for k, v in var.vpc_endpoints : k => length(try(v.subnet_scope, [])) > 0 ? flatten([
      for scope in v.subnet_scope :
      scope == "private" ? (length(aws_subnet.private) > 0 ? aws_subnet.private[*].id : []) : (scope == "public" ? (length(aws_subnet.public) > 0 ? aws_subnet.public[*].id : []) : [])
    ]) : v.subnet_ids
    if v.vpc_endpoint_type == "Interface"
  }
  need_endpoints_sg = length([for k, v in var.vpc_endpoints : k if v.vpc_endpoint_type == "Interface" && length(try(v.security_group_ids, [])) == 0]) > 0
}

# Security group for Interface VPC endpoints: allow HTTPS from VPC
resource "aws_security_group" "vpc_endpoints" {
  count = local.need_endpoints_sg ? 1 : 0

  name        = "${var.vpc_name}-vpc-endpoints"
  description = "Allow HTTPS from VPC for interface endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.vpc_name}-vpc-endpoints" })
}

resource "aws_vpc_endpoint" "this" {
  for_each = var.vpc_endpoints

  vpc_id              = aws_vpc.this.id
  service_name        = each.value.service_name
  vpc_endpoint_type   = each.value.vpc_endpoint_type
  subnet_ids          = each.value.vpc_endpoint_type == "Interface" ? local.interface_endpoint_subnet_ids[each.key] : null
  security_group_ids  = each.value.vpc_endpoint_type == "Interface" ? (length(try(each.value.security_group_ids, [])) > 0 ? each.value.security_group_ids : [aws_security_group.vpc_endpoints[0].id]) : null
  private_dns_enabled = each.value.vpc_endpoint_type == "Interface" ? try(each.value.private_dns_enabled, true) : null
  route_table_ids     = each.value.vpc_endpoint_type == "Gateway" ? local.endpoint_route_table_ids[each.key] : null

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-${each.key}-endpoint"
    }
  )
}
