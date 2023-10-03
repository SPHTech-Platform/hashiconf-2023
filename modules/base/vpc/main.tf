#trivy:ignore:AVD-AWS-0102
#trivy:ignore:AVD-AWS-0105
#trivy:ignore:AVD-AWS-0178
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1.2"

  name = var.name
  cidr = var.cidr

  secondary_cidr_blocks = var.secondary_cidr_blocks

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 4)]

  private_subnet_tags = {
    "type" = "private"
  }
  public_subnet_tags = {
    "type" = "public"
  }

  create_database_subnet_group  = false
  manage_default_network_acl    = true
  manage_default_route_table    = true
  manage_default_security_group = true

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_max_aggregation_interval               = 60 #seconds
  flow_log_cloudwatch_log_group_retention_in_days = 60 #days

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = false
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.azs_count)
}


data "aws_availability_zones" "available" {
}

resource "aws_db_subnet_group" "database" {
  name       = "${var.name}-database"
  subnet_ids = module.vpc.private_subnets
}
