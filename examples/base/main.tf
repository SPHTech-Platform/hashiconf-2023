module "base" {
  source = "../../modules/base"

  providers = {
    aws.tgw = aws.tgw
    aws.a   = aws.a
    aws.b   = aws.b
  }

  hvn_id         = "hashiconf"
  hvn_cidr_block = "10.129.0.0/16"

  consul_tier            = "standard"
  consul_size            = "small"
  consul_datacenter      = "aws-ap-southeast-1"
  consul_public_endpoint = true

  tgw_cidr = "10.128.0.0/16"

  a_routeable_cidr = "10.130.0.0/16"
  b_routeable_cidr = "10.131.0.0/16"
}
