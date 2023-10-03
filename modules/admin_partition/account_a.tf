module "consul_cluster_account_a" {
  source = "./modules/eks"

  providers = {
    aws        = aws.a
    kubernetes = kubernetes.a
    helm       = helm.a
  }

  cluster_name                         = var.a_cluster_name
  vpc_id                               = var.a_vpc_id
  subnet_ids                           = var.a_private_subnets
  consul_subnet_ids                    = var.a_routeable_subnets
  role_mapping                         = var.a_eks_role_mapping
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = var.a_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.a_cluster_endpoint_public_access_cidrs

  aws_auth_fargate_profile_pod_execution_role_arns = values(
    module.frontend_fargate_profile.fargate_profile_pod_execution_role_arn
  )
}

module "consul_k8s_account_a" {
  source = "./modules/consul_k8s"

  providers = {
    kubernetes = kubernetes.a
    helm       = helm.a
  }

  cluster_name = module.consul_cluster_account_a.cluster_name

  partition_prefix = "a"
  k8s_auth_host    = module.consul_cluster_account_a.cluster_endpoint
  external_servers = var.consul_addr

  chart_version    = var.consul_chart_version
  consul_image_tag = var.consul_image_tag

  mesh_gateway_enabled    = true
  ingress_gateway_enabled = true
  ingress_gateway_service_ports = [
    {
      port     = 5432
      nodePort = null
    },
  ]
}

resource "kubernetes_namespace" "frontend" {
  provider = kubernetes.a

  metadata {
    annotations = {
      name = var.a_eks_namespace
    }
    name = var.a_eks_namespace
  }
}

module "frontend_fargate_profile" {
  source  = "SPHTech-Platform/eks/aws//modules/fargate_profile"
  version = "~> 0.15.0"

  providers = {
    kubernetes = kubernetes.a
    aws        = aws.a
  }

  create_aws_observability_ns     = false
  create_fargate_logger_configmap = false
  create_fargate_log_group        = false

  cluster_name = var.a_cluster_name
  fargate_profiles = {
    (var.a_eks_namespace) = {
      subnet_ids = var.a_private_subnets
      selectors = [
        {
          namespace = kubernetes_namespace.frontend.id
        }
      ]
    }
  }
}
