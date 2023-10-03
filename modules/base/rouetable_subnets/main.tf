locals {
  azs     = toset(slice(data.aws_availability_zones.available.names, 0, var.azs_count))
  cidrs   = cidrsubnets(var.routeable_subnets_cidr, [for n in range(var.azs_count) : ceil(log(var.azs_count, 2))]...)
  subnets = zipmap(local.azs, local.cidrs)

  public_subnet_id_azs = {
    for _id, subnet in data.aws_subnet.public_subnet : subnet.id => subnet.availability_zone
  }
  public_ngw_ids = {
    for _az, ngw in data.aws_nat_gateway.public : local.public_subnet_id_azs[ngw.subnet_id] => ngw.id
  }
}

resource "aws_subnet" "routeable" {
  for_each = local.subnets

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name                              = "routeable-${each.key}"
    type                              = "routeable"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_network_acl_association" "routeable" {
  for_each = local.subnets

  network_acl_id = var.network_acl_id
  subnet_id      = aws_subnet.routeable[each.key].id
}

resource "aws_route_table" "routeable" {
  for_each = local.subnets

  vpc_id = var.vpc_id

  tags = {
    Name = "routeable-${each.key}"
  }
}

resource "aws_route_table_association" "routeable" {
  for_each = local.subnets

  subnet_id      = aws_subnet.routeable[each.key].id
  route_table_id = aws_route_table.routeable[each.key].id
}

resource "aws_nat_gateway" "private" {
  for_each = local.subnets

  connectivity_type = "private"
  subnet_id         = aws_subnet.routeable[each.key].id
  tags = {
    Name = "routeable-${each.key}"
  }
}
