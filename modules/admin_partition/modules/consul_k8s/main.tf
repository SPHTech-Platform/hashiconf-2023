resource "kubernetes_namespace" "consul" {
  metadata {
    name   = var.consul_namespace
    labels = var.kubermetes_labels

    annotations = {
      name = var.consul_namespace
    }
  }
}

resource "kubernetes_secret_v1" "bootstrap_token" {
  metadata {
    name      = "consul-bootstrap-token"
    namespace = kubernetes_namespace.consul.metadata[0].name
  }
  data = {
    "token" = local.bootstrap_token
  }

  type = "Opaque"
}

resource "helm_release" "consul_client" {
  name             = var.release_name
  repository       = var.chart_repository
  chart            = var.chart_name
  version          = var.chart_version
  namespace        = kubernetes_namespace.consul.metadata[0].name
  create_namespace = var.create_namespace

  timeout = 600 # Fargate is slow...

  values = [
    templatefile("${path.module}/templates/values.yaml", local.values),
  ]
}

locals {
  values = {
    datacenter              = var.datacenter
    log_level               = var.log_level
    image                   = "${var.consul_image_name}:${var.consul_image_tag}"
    admin_partition_enabled = var.admin_partition_enabled
    admin_partition         = var.admin_partition_enabled ? consul_admin_partition.main[0].name : ""
    k8s_auth_host           = var.k8s_auth_host
    envoy_extra_args        = var.envoy_extra_args != null ? var.envoy_extra_args : "null"
    external_servers        = jsonencode(var.external_servers)
    extra_labels            = jsonencode(var.extra_labels)

    ingress_gateway_enabled       = var.ingress_gateway_enabled
    ingress_gateway_replicas      = var.ingress_gateway_replicas
    ingress_gateway_service_type  = var.ingress_gateway_service_type
    ingress_gateway_annotations   = yamlencode(local.ingress_gateway_annotations)
    ingress_gateway_service_ports = jsonencode(var.ingress_gateway_service_ports)

    mesh_gateway_enabled            = var.mesh_gateway_enabled
    mesh_gateway_replicas           = var.mesh_gateway_replicas
    mesh_gateway_service_type       = var.mesh_gateway_service_type
    mesh_gateway_service_port       = var.mesh_gateway_service_port
    mesh_gateway_annotations        = yamlencode(var.mesh_gateway_annotations)
    mesh_gateway_container_port     = var.mesh_gateway_container_port
    mesh_gateway_wan_address_source = var.mesh_gateway_wan_address_source
    mesh_gateway_wan_address_port   = var.mesh_gateway_wan_address_port

    dns_enabled            = var.dns_enabled
    dns_enable_redirection = var.dns_enable_redirection
    dns_cluster_ip         = var.dns_cluster_ip

    acl_bootstrap_token = yamlencode({
      secretName = kubernetes_secret_v1.bootstrap_token.metadata[0].name
      secretKey  = "token"
    })
  }

  ingress_gateway_annotations = merge(var.ingress_gateway_annotations, local.ingress_gateway_annotations_sg, local.ingress_gateway_annotations_subnet)
  ingress_gateway_annotations_sg = length(var.ingress_gateway_security_group_ids) > 0 ? {
    "service.beta.kubernetes.io/aws-load-balancer-security-groups" = join(",", var.ingress_gateway_security_group_ids)
  } : {}
  ingress_gateway_annotations_subnet = length(var.ingress_gateway_subnet_ids) > 0 ? {
    "service.beta.kubernetes.io/aws-load-balancer-subnets" = join(",", var.ingress_gateway_subnet_ids)
  } : {}
}
