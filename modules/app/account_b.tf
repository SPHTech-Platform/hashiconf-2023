resource "consul_config_entry" "backend_service_defaults" {
  kind      = "service-defaults"
  name      = var.b_service_name
  namespace = var.b_eks_namespace
  partition = local.b_admin_partition_name

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "exported_services" {
  count = var.expose_backend_to_frontend ? 1 : 0

  kind      = "exported-services"
  name      = local.b_admin_partition_name
  partition = local.b_admin_partition_name

  config_json = jsonencode({
    Services = [
      {
        Name      = var.b_service_name
        Namespace = var.b_eks_namespace
        Consumers = [
          {
            Partition = local.a_admin_partition_name
          },
        ]
      },
      {
        Name      = "mesh-gateway"
        Namespace = "default"
        Consumers = [
          {
            Partition = local.a_admin_partition_name
          }
        ]
      }
    ]
  })
}

resource "consul_config_entry" "allow_frontend" {
  count = var.expose_backend_to_frontend ? 1 : 0

  kind      = "service-intentions"
  partition = local.b_admin_partition_name
  namespace = var.b_eks_namespace
  name      = var.b_service_name

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = var.a_service_name
        Precedence = 1
        Type       = "consul"
        Namespace  = var.a_eks_namespace
        Partition  = local.a_admin_partition_name
      }
    ]
  })
}

resource "kubernetes_manifest" "backend_apps" {
  for_each = fileset(local.backend_templates_path, "*")

  provider = kubernetes.b

  manifest = yamldecode(
    templatefile("${local.backend_templates_path}/${each.value}", local.backend_app_vars)
  )

  field_manager {
    force_conflicts = true
  }
}

moved {
  from = consul_config_entry.allow_backend
  to   = consul_config_entry.allow_frontend
}
