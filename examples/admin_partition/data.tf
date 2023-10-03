locals {
  # Use `terraform_remote_state` or `tfe_outputs` data sources as appropriate
  base_outputs = {}

  eks_master_roles = []
}

####
# A
####
data "aws_eks_cluster" "a" {
  provider = aws.a

  name = module.partitions.a_cluster_name
}

data "aws_eks_cluster_auth" "a" {
  provider = aws.a

  name = module.partitions.a_cluster_name
}

####
# B
####
data "aws_eks_cluster" "b" {
  provider = aws.b

  name = module.partitions.b_cluster_name
}

data "aws_eks_cluster_auth" "b" {
  provider = aws.b

  name = module.partitions.b_cluster_name
}
