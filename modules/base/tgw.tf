#trivy:ignore:AVD-AWS-0102
#trivy:ignore:AVD-AWS-0105
#trivy:ignore:AVD-AWS-0178
module "tgw_vpc" {
  source = "./vpc"

  providers = {
    aws = aws.tgw
  }

  name = var.tgw_name
  cidr = var.tgw_cidr

  add_subnet_autodiscovery_annotations = true
}

module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.10.0"

  providers = {
    aws = aws.tgw
  }

  name = var.tgw_name

  # When "true" there is no need for RAM resources if using multiple AWS accounts
  enable_auto_accept_shared_attachments = true

  ram_allow_external_principals = true
  ram_principals                = [hcp_hvn.this.provider_account_id]

  vpc_attachments = {
    tgw_vpc = {
      vpc_id       = module.tgw_vpc.vpc_id
      subnet_ids   = module.tgw_vpc.private_subnets
      dns_support  = true
      ipv6_support = false
    }
  }
}


resource "aws_ec2_tag" "tgw_a_attachment" {
  provider = aws.tgw

  resource_id = module.a_routeable.tgw_attachment_id
  key         = "Name"
  value       = "account_a"
}

resource "aws_ec2_tag" "tgw_b_attachment" {
  provider = aws.tgw

  resource_id = module.b_routeable.tgw_attachment_id
  key         = "Name"
  value       = "account_b"
}

resource "aws_ec2_tag" "hvn_attachment" {
  provider = aws.tgw

  resource_id = hcp_aws_transit_gateway_attachment.this.provider_transit_gateway_attachment_id
  key         = "Name"
  value       = "hvn"
}

locals {
  tgw_rouetable_to_tgw = { for pair in setproduct(module.tgw_vpc.private_route_table_ids, var.routeable_cidr) : join(";", pair) => {
    route_table_id = pair[0]
    cidr_block     = pair[1]
  } }
}

resource "aws_route" "private_subnet_to_tgw" {
  for_each = local.tgw_rouetable_to_tgw

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.cidr_block
  transit_gateway_id     = module.tgw.ec2_transit_gateway_id
}
