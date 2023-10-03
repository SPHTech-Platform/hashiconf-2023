module "eks" {
  source  = "SPHTech-Platform/eks/aws"
  version = "~> 0.16.0"

  count = local.create_eks ? 1 : 0

  fargate_cluster = true
  fargate_profiles = {
    consul = {
      subnet_ids = var.consul_subnet_ids
      selectors = [
        {
          namespace = "consul"
        }
      ]
    }
  }

  cluster_endpoint_private_access       = var.cluster_endpoint_private_access
  cluster_endpoint_public_access        = var.cluster_endpoint_public_access
  create_cluster_security_group         = var.create_cluster_security_group
  create_node_security_group            = var.create_node_security_group
  cluster_endpoint_public_access_cidrs  = var.cluster_endpoint_public_access_cidrs
  cluster_additional_security_group_ids = var.cluster_additional_security_group_ids

  create_aws_auth_configmap = var.create_aws_auth_configmap
  manage_aws_auth_configmap = var.manage_aws_auth_configmap

  skip_asg_role   = var.skip_asg_role
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  role_mapping    = var.role_mapping

  aws_auth_fargate_profile_pod_execution_role_arns = var.aws_auth_fargate_profile_pod_execution_role_arns
}

module "lb_controller" {
  source  = "SPHTech-Platform/lb-controller/aws"
  version = "~> 0.7.0"

  count = local.create_eks ? 1 : 0

  cluster_name      = module.eks[0].cluster_name
  oidc_provider_arn = module.eks[0].oidc_provider_arn
  vpc_id            = var.vpc_id

  chart_version = var.lb_controller_chart_version
  image_tag     = var.lb_controller_image_tag
}
