resource "hcp_hvn" "this" {
  hvn_id         = var.hvn_id
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = var.hvn_cidr_block
}

resource "hcp_aws_transit_gateway_attachment" "this" {
  hvn_id                        = hcp_hvn.this.hvn_id
  transit_gateway_attachment_id = var.hvn_id
  transit_gateway_id            = module.tgw.ec2_transit_gateway_id
  resource_share_arn            = module.tgw.ram_resource_share_id
}

resource "hcp_hvn_route" "rouetable" {
  for_each = var.routeable_cidr

  hvn_link         = hcp_hvn.this.self_link
  hvn_route_id     = "tgw-${replace(each.key, "/[^A-z0-9]/", "-")}"
  destination_cidr = each.key
  target_link      = hcp_aws_transit_gateway_attachment.this.self_link
}
