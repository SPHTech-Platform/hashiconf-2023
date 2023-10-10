locals {
  tgw_admin_partition_name = module.consul_k8s_account_tgw.consul_admin_partition
}

module "consul_cluster_account_tgw" {
  source  = "app.terraform.io/sph/hcp-consul-client/aws"
  version = "~> 0.2.0"

  providers = {
    aws        = aws.tgw
    kubernetes = kubernetes.tgw
    helm       = helm.tgw
  }

  cluster_name                         = var.tgw_cluster_name
  vpc_id                               = var.tgw_vpc_id
  subnet_ids                           = var.tgw_private_subnets
  consul_subnet_ids                    = var.tgw_routeable_subnets
  role_mapping                         = var.tgw_eks_role_mapping
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = var.tgw_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.tgw_cluster_endpoint_public_access_cidrs
}

module "consul_k8s_account_tgw" {
  source  = "app.terraform.io/sph/hcp-consul-client/aws//modules/eks"
  version = "~> 0.2.0"

  providers = {
    kubernetes = kubernetes.tgw
    helm       = helm.tgw
  }

  cluster_name = module.consul_cluster_account_tgw.cluster_name

  partition_prefix = "tgw"
  k8s_auth_host    = module.consul_cluster_account_tgw.cluster_endpoint
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

resource "consul_config_entry" "tgw_ingress_gateway" {
  name      = var.tgw_ingress_gateway
  kind      = "ingress-gateway"
  partition = local.tgw_admin_partition_name

  config_json = jsonencode({
    TLS = {
      Enabled = false
    }
    Listeners = [
      {
        Port     = 5432
        Protocol = "tcp"
        Services = [
          {
            Name      = consul_service.rds_a.name
            Partition = local.a_admin_partition_name
          }
        ]
      },
    ]
  })
}

resource "consul_config_entry" "tgw_proxy_defaults" {
  kind      = "proxy-defaults"
  name      = "global"
  namespace = "default"
  partition = local.tgw_admin_partition_name

  config_json = jsonencode({
    Protocol = "tcp"
    MeshGateway = {
      Mode = "local"
    }
  })
}
