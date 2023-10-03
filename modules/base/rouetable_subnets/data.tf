data "aws_availability_zones" "available" {
}

data "aws_subnet" "public_subnet" {
  for_each = var.public_subnets

  id = each.key

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:type"
    values = ["public"]
  }
}

data "aws_nat_gateway" "public" {
  for_each = local.public_subnet_id_azs

  subnet_id = each.key
}

data "aws_subnet" "private_subnet" {
  for_each = var.private_subnets

  id = each.key

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:type"
    values = ["private"]
  }
}

data "aws_route_table" "private_route_table" {
  for_each = var.private_subnets

  subnet_id = each.key
}
