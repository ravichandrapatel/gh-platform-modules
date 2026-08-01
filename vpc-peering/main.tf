# VPC Peering: connection between two VPCs with optional route table updates.

resource "aws_vpc_peering_connection" "this" {
  peer_vpc_id = var.peer_vpc_id
  vpc_id      = var.vpc_id
  auto_accept = var.auto_accept

  tags = var.tags
}

# Routes in requester VPC to peer VPC
resource "aws_route" "requester" {
  count = length(var.requester_route_table_ids)

  route_table_id            = var.requester_route_table_ids[count.index]
  destination_cidr_block    = var.peer_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

# Routes in accepter VPC to requester VPC
resource "aws_route" "accepter" {
  count = length(var.accepter_route_table_ids)

  route_table_id            = var.accepter_route_table_ids[count.index]
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

# DNS resolution across the peering: lets each VPC resolve the other's
# private hosted zone / private DNS names (same-account, auto-accepted peering)
resource "aws_vpc_peering_connection_options" "this" {
  count = var.allow_remote_vpc_dns_resolution ? 1 : 0

  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
