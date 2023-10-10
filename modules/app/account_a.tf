resource "consul_config_entry" "frontend_service_defaults" {
  kind      = "service-defaults"
  name      = var.a_service_name
  namespace = var.a_eks_namespace
  partition = local.a_admin_partition_name

  config_json = jsonencode({
    Protocol = "http"
    MeshGateway = {
      Mode = "local"
    }
  })
}

resource "kubernetes_manifest" "frontend_app" {
  for_each = fileset(local.frontend_templates_path, "*")

  provider = kubernetes.a

  manifest = yamldecode(
    templatefile("${local.frontend_templates_path}/${each.value}", local.frontend_app_vars)
  )

  field_manager {
    force_conflicts = true
  }
}


resource "kubernetes_manifest" "hashicups_product_api" {
  for_each = fileset(local.hashicups.products_api.template_path, "*")

  provider = kubernetes.a

  manifest = yamldecode(
    templatefile("${local.hashicups.products_api.template_path}/${each.value}", local.hashicups.products_api.app_vars)
  )

  field_manager {
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "hashicups_public_api" {
  for_each = fileset(local.hashicups.public_api.template_path, "*")

  provider = kubernetes.a

  manifest = yamldecode(
    templatefile("${local.hashicups.public_api.template_path}/${each.value}", local.hashicups.public_api.app_vars)
  )

  field_manager {
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "hashicups_nginx" {
  for_each = fileset(local.hashicups.nginx.template_path, "*")

  provider = kubernetes.a

  manifest = yamldecode(
    templatefile("${local.hashicups.nginx.template_path}/${each.value}", local.hashicups.nginx.app_vars)
  )

  field_manager {
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "hashicups_payment" {
  for_each = fileset(local.hashicups.payments.template_path, "*")

  provider = kubernetes.a

  manifest = yamldecode(
    templatefile("${local.hashicups.payments.template_path}/${each.value}", local.hashicups.payments.app_vars)
  )

  field_manager {
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "hashicups_frontend" {
  for_each = fileset(local.hashicups.frontend.template_path, "*")

  provider = kubernetes.a

  manifest = yamldecode(
    templatefile("${local.hashicups.frontend.template_path}/${each.value}", local.hashicups.frontend.app_vars)
  )

  field_manager {
    force_conflicts = true
  }
}

#################
# Intenions
#################

resource "consul_config_entry" "hashicups_public_api_intentions" {
  kind      = "service-intentions"
  partition = local.a_admin_partition_name
  namespace = var.a_eks_namespace
  name      = local.hashicups.public_api.app_vars.public_api_hashicups_service_name

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = local.hashicups.frontend.app_vars.frontend_hashicups_service_name
        Precedence = 1
        Type       = "consul"
        Namespace  = var.a_eks_namespace
        Partition  = local.a_admin_partition_name
      },
      {
        Action     = "allow"
        Name       = local.hashicups.nginx.app_vars.nginx_hashicups_service_name
        Precedence = 1
        Type       = "consul"
        Namespace  = var.a_eks_namespace
        Partition  = local.a_admin_partition_name
      }
    ]
  })
}
resource "consul_config_entry" "hashicups_product_api_intentions" {
  kind      = "service-intentions"
  partition = local.a_admin_partition_name
  namespace = var.a_eks_namespace
  name      = local.hashicups.products_api.app_vars.product_api_hashicups_service_name

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = local.hashicups.public_api.app_vars.public_api_hashicups_service_name
        Precedence = 1
        Type       = "consul"
        Namespace  = var.a_eks_namespace
        Partition  = local.a_admin_partition_name
      },
    ]
  })
}

resource "consul_config_entry" "hashicups_payments_intentions" {
  kind      = "service-intentions"
  partition = local.a_admin_partition_name
  namespace = var.a_eks_namespace
  name      = local.hashicups.payments.app_vars.payments_hashicups_service_name

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = local.hashicups.public_api.app_vars.public_api_hashicups_service_name
        Precedence = 1
        Type       = "consul"
        Namespace  = var.a_eks_namespace
        Partition  = local.a_admin_partition_name
      },
    ]
  })
}

resource "consul_config_entry" "hashicups_frontend_intentions" {
  kind      = "service-intentions"
  partition = local.a_admin_partition_name
  namespace = var.a_eks_namespace
  name      = local.hashicups.frontend.app_vars.frontend_hashicups_service_name

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = local.hashicups.nginx.app_vars.nginx_hashicups_service_name
        Precedence = 1
        Type       = "consul"
        Namespace  = var.a_eks_namespace
        Partition  = local.a_admin_partition_name
      },
    ]
  })
}

##################
# Service Defaults
##################
resource "consul_config_entry" "hashicups_frontend_service_defaults" {
  kind      = "service-defaults"
  name      = local.hashicups.frontend.app_vars.frontend_hashicups_service_name
  namespace = var.a_eks_namespace
  partition = local.a_admin_partition_name

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "hashicups_nginx_service_defaults" {
  kind      = "service-defaults"
  name      = local.hashicups.nginx.app_vars.nginx_hashicups_service_name
  namespace = var.a_eks_namespace
  partition = local.a_admin_partition_name

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "hashicups_payments_service_defaults" {
  kind      = "service-defaults"
  name      = local.hashicups.payments.app_vars.payments_hashicups_service_name
  namespace = var.a_eks_namespace
  partition = local.a_admin_partition_name

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "hashicups_products_api_service_defaults" {
  kind      = "service-defaults"
  name      = local.hashicups.products_api.app_vars.product_api_hashicups_service_name
  namespace = var.a_eks_namespace
  partition = local.a_admin_partition_name

  config_json = jsonencode({
    Protocol = "http"
  })
}

resource "consul_config_entry" "hashicups_public_api_service_defaults" {
  kind      = "service-defaults"
  name      = local.hashicups.public_api.app_vars.public_api_hashicups_service_name
  namespace = var.a_eks_namespace
  partition = local.a_admin_partition_name

  config_json = jsonencode({
    Protocol = "http"
  })
}
