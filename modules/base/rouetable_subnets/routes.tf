locals {
  nonrouteable_to_rouetable = { for pair in setproduct(var.private_subnets, var.routeable_cidr) : join(";", pair) => {
    subnet_id  = pair[0]
    cidr_block = pair[1]
  } }

  rouetable_to_tgw = { for pair in setproduct(local.azs, var.routeable_cidr) : join(";", pair) => {
    az         = pair[0]
    cidr_block = pair[1]
  } }
}

# Route internet traffic from Routeable subnets to the public NAT Gateway in the same AZ
resource "aws_route" "routeable_to_internet" {
  for_each = local.subnets

  route_table_id         = aws_route_table.routeable[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = local.public_ngw_ids[each.key]
}

# Route traffic from non-routeable subnets to Routeable TGW network to the private NAT Gateway in the same AZ
resource "aws_route" "nonrouteable_to_rouetable" {
  for_each = local.nonrouteable_to_rouetable

  route_table_id         = data.aws_route_table.private_route_table[each.value.subnet_id].id
  destination_cidr_block = each.value.cidr_block
  nat_gateway_id         = aws_nat_gateway.private[data.aws_subnet.private_subnet[each.value.subnet_id].availability_zone].id
}

# Route from routeable subnet to TGW CIDRs
resource "aws_route" "to_tgw" {
  for_each = local.rouetable_to_tgw

  route_table_id         = aws_route_table.routeable[each.value.az].id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = time_sleep.tgw_attachment.triggers.tgw_id
}
