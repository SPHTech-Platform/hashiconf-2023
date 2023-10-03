module "consul_cluster_account_b" {
  source = "./modules/eks"

  providers = {
    aws        = aws.b
    kubernetes = kubernetes.b
    helm       = helm.b
  }

  cluster_name                         = var.b_cluster_name
  vpc_id                               = var.b_vpc_id
  subnet_ids                           = var.b_private_subnets
  consul_subnet_ids                    = var.b_routeable_subnets
  role_mapping                         = var.b_eks_role_mapping
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = var.b_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.b_cluster_endpoint_public_access_cidrs

  aws_auth_fargate_profile_pod_execution_role_arns = values(
    module.backend_fargate_profile.fargate_profile_pod_execution_role_arn
  )
}

module "consul_k8s_account_b" {
  source = "./modules/consul_k8s"

  providers = {
    kubernetes = kubernetes.b
    helm       = helm.b
  }

  cluster_name = module.consul_cluster_account_b.cluster_name

  partition_prefix = "b"
  k8s_auth_host    = module.consul_cluster_account_b.cluster_endpoint
  external_servers = var.consul_addr

  chart_version    = var.consul_chart_version
  consul_image_tag = var.consul_image_tag

  mesh_gateway_enabled = true
}

resource "kubernetes_namespace" "backend" {
  provider = kubernetes.b

  metadata {
    annotations = {
      name = var.b_eks_namespace
    }
    name = var.b_eks_namespace
  }
}

module "backend_fargate_profile" {
  source  = "SPHTech-Platform/eks/aws//modules/fargate_profile"
  version = "~> 0.15.0"

  providers = {
    kubernetes = kubernetes.b
    aws        = aws.b
  }

  create_aws_observability_ns     = false
  create_fargate_logger_configmap = false
  create_fargate_log_group        = false

  cluster_name = var.b_cluster_name
  fargate_profiles = {
    (var.b_eks_namespace) = {
      subnet_ids = var.b_private_subnets
      selectors = [
        {
          namespace = kubernetes_namespace.backend.id
        }
      ]
    }
  }
}
