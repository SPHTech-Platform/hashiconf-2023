locals {
  # Use `terraform_remote_state` or `tfe_outputs` data sources as appropriate
  base_outputs = {}
}

####
# A
####
data "aws_eks_cluster" "a" {
  provider = aws.a

  name = "consul-a"
}

data "aws_eks_cluster_auth" "a" {
  provider = aws.a

  name = "consul-a"
}

data "aws_secretsmanager_secret" "a_rds_password" {
  provider = aws.a

  arn = local.base_outputs.a_rds_password[0].secret_arn
}

data "aws_secretsmanager_secret_version" "a_rds_password" {
  provider = aws.a

  secret_id = data.aws_secretsmanager_secret.a_rds_password.id
}

data "kubernetes_service" "a_ingress_gateway" {
  provider = kubernetes.a

  metadata {
    name      = "consul-ingress-gateway"
    namespace = "consul"
  }
}

####
# B
####
data "aws_eks_cluster" "b" {
  provider = aws.b

  name = "consul-b"
}

data "aws_eks_cluster_auth" "b" {
  provider = aws.b

  name = "consul-b"
}
