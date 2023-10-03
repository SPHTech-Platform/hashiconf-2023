resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.tgw_id
  vpc_id             = var.vpc_id
  subnet_ids         = [for _az, subnet in aws_subnet.routeable : subnet.id]

  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  dns_support  = "enable"
  ipv6_support = "disable"

  tags = {
    "Name" = "routeable-tgw"
  }

  lifecycle {
    ignore_changes = [
      # The following arguments cannot be configured or perform drift
      # detection with Resource Access Manager (RAM) shared
      # Transit Gateways.
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation,
    ]
  }
}

# Sleep for 60s before attaching routes
resource "time_sleep" "tgw_attachment" {
  create_duration = "60s"

  triggers = {
    attachment_id = aws_ec2_transit_gateway_vpc_attachment.this.id
    tgw_id        = aws_ec2_transit_gateway_vpc_attachment.this.transit_gateway_id
  }
}
