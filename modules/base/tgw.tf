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
