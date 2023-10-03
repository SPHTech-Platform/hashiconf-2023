#trivy:ignore:AVD-AWS-0102
#trivy:ignore:AVD-AWS-0105
#trivy:ignore:AVD-AWS-0178
module "a_vpc" {
  source = "./vpc"

  providers = {
    aws = aws.a
  }

  name = var.a_name
  cidr = var.a_cidr

  secondary_cidr_blocks = [var.a_routeable_cidr]
}

module "a_routeable" {
  source = "./rouetable_subnets"

  providers = {
    aws = aws.a
  }

  vpc_id          = module.a_vpc.vpc_id
  network_acl_id  = module.a_vpc.default_network_acl_id
  public_subnets  = module.a_vpc.public_subnets
  private_subnets = module.a_vpc.private_subnets

  routeable_subnets_cidr = var.a_routeable_cidr

  routeable_cidr = var.routeable_cidr

  tgw_id = module.tgw.ec2_transit_gateway_id
}
