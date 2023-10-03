#trivy:ignore:AVD-AWS-0102
#trivy:ignore:AVD-AWS-0105
#trivy:ignore:AVD-AWS-0178
module "b_vpc" {
  source = "./vpc"

  providers = {
    aws = aws.b
  }

  name = var.b_name
  cidr = var.b_cidr

  secondary_cidr_blocks = [var.b_routeable_cidr]
}

module "b_routeable" {
  source = "./rouetable_subnets"

  providers = {
    aws = aws.b
  }

  vpc_id          = module.b_vpc.vpc_id
  network_acl_id  = module.b_vpc.default_network_acl_id
  public_subnets  = module.b_vpc.public_subnets
  private_subnets = module.b_vpc.private_subnets

  routeable_subnets_cidr = var.b_routeable_cidr

  routeable_cidr = var.routeable_cidr

  tgw_id = module.tgw.ec2_transit_gateway_id
}
