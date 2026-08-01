# Client VPN endpoint: single endpoint with optional authentication, logging, and network associations.

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = var.name
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = var.split_tunnel
  dns_servers            = var.dns_servers
  transport_protocol     = var.transport_protocol
  vpc_id                 = var.vpc_id
  security_group_ids     = var.security_group_ids
  self_service_portal    = var.self_service_portal

  dynamic "authentication_options" {
    for_each = var.authentication_options
    content {
      type                           = authentication_options.value.type
      active_directory_id            = authentication_options.value.active_directory_id
      root_certificate_chain_arn     = authentication_options.value.root_certificate_chain_arn
      saml_provider_arn              = authentication_options.value.saml_provider_arn
      self_service_saml_provider_arn = authentication_options.value.self_service_saml_provider_arn
    }
  }

  connection_log_options {
    enabled               = var.connection_log_options.enabled
    cloudwatch_log_group  = var.connection_log_options.cloudwatch_log_group
    cloudwatch_log_stream = var.connection_log_options.cloudwatch_log_stream
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_ec2_client_vpn_network_association" "this" {
  for_each = toset(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = each.value

  lifecycle {
    # The security groups are managed via the endpoint's target network association
    # but the resource for association doesn't expose them directly in a way that
    # is easily managed if they change. However, aws_ec2_client_vpn_network_association
    # doesn't have security_groups attribute. It's actually managed via
    # aws_ec2_client_vpn_endpoint's security_group_ids if provided, or via
    # a separate resource if needed.
    # Actually, security_group_ids is an attribute of aws_ec2_client_vpn_endpoint.
  }
}

# Authorization rules
resource "aws_ec2_client_vpn_authorization_rule" "this" {
  for_each = { for idx, rule in var.authorization_rules : idx => rule }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = each.value.target_network_cidr
  access_group_id        = each.value.access_group_id
  authorize_all_groups   = each.value.authorize_all_groups
  description            = each.value.description
}

# Routes
resource "aws_ec2_client_vpn_route" "this" {
  for_each = { for idx, route in var.routes : idx => route }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = each.value.destination_cidr_block
  target_vpc_subnet_id   = each.value.target_vpc_subnet_id
  description            = each.value.description

  depends_on = [aws_ec2_client_vpn_network_association.this]
}
