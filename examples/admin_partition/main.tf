module "partitions" {
  source = "../../modules/admin_partition"

  providers = {
    aws.a = aws.a
    aws.b = aws.b

    kubernetes.a = kubernetes.a
    kubernetes.b = kubernetes.b

    helm.a = helm.a
    helm.b = helm.b
  }

  consul_addr        = [nonsensitive(replace(local.base_outputs.consul_private_url, "https://", ""))]
  consul_public_addr = local.base_outputs.consul_public_url

  a_vpc_id            = nonsensitive(local.base_outputs.a_vpc_id)
  a_private_subnets   = nonsensitive(local.base_outputs.a_private_subnets)
  a_routeable_subnets = nonsensitive(local.base_outputs.a_routeable_subnets)

  a_eks_role_mapping = [
    for role in local.eks_master_roles :
    {
      rolearn  = role.arn
      groups   = ["system:masters"]
      username = role.user
    }
  ]

  a_rds_address = nonsensitive(local.base_outputs.a_rds_address)

  b_vpc_id            = nonsensitive(local.base_outputs.b_vpc_id)
  b_private_subnets   = nonsensitive(local.base_outputs.b_private_subnets)
  b_routeable_subnets = nonsensitive(local.base_outputs.b_routeable_subnets)

  b_eks_role_mapping = [
    for role in local.eks_master_roles :
    {
      rolearn  = role.arn
      groups   = ["system:masters"]
      username = role.user
    }
  ]
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
}
