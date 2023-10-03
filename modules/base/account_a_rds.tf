module "rds_a" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 8.3.1"

  providers = {
    aws = aws.a
  }

  name                 = var.a_name
  db_subnet_group_name = module.a_vpc.database_subnet_group
  engine               = "aurora-postgresql"
  engine_mode          = "provisioned"
  engine_version       = "14.6"
  storage_encrypted    = true
  master_username      = "root"

  vpc_id  = module.a_vpc.vpc_id
  subnets = module.a_vpc.private_subnets

  ca_cert_identifier = "rds-ca-rsa4096-g1"

  vpc_security_group_ids = [
    aws_security_group.a_rds.id,
  ]

  apply_immediately = true


  enabled_cloudwatch_logs_exports = ["postgresql"]

  create_security_group = false

  monitoring_interval = 60
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 2
    max_capacity = 4
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
  }

  manage_master_user_password = true
  backup_retention_period     = 1

  preferred_backup_window = ""
}

resource "aws_security_group" "a_rds" {
  #checkov:skip=CKV2_AWS_5

  provider = aws.a

  name        = "${var.a_name}-rds"
  description = "Ingress connection for Postgres"
  vpc_id      = module.a_vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "a_rds_vpc" {
  for_each = toset([var.a_cidr, var.a_routeable_cidr])

  provider = aws.a

  security_group_id = aws_security_group.a_rds.id

  description = "Ingress connection for Postgres from VPC CIDR"

  cidr_ipv4   = each.key
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

}
