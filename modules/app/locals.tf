
locals {
  a_admin_partition_name = "a-${data.aws_caller_identity.a.account_id}"
  b_admin_partition_name = "b-${data.aws_caller_identity.b.account_id}"

  frontend_templates_path = "${path.module}/templates/frontend-fakeservice"
  backend_templates_path  = "${path.module}/templates/backend-fakeservice"

  backend_app_vars = {
    backend_service_name = var.b_service_name
    backend_namespace    = var.b_eks_namespace
  }

  frontend_app_vars = {
    frontend_service_name   = var.a_service_name
    frontend_namespace      = var.a_eks_namespace
    upstream_consul_address = "backend.svc.backend.ns.b-479598235523.ap:9090" # TODO: make this dynamic
  }

  hashicups = {
    products_api = {
      template_path = "${path.module}/templates/hashicups/product-api"
      app_vars = {
        product_api_hashicups_service_name  = "product-api"
        frontend_namespace                  = var.a_eks_namespace
        postgres_db_upstream_consul_address = "a-rds.svc.default.ns.a-479598235523.ap:5432"                                                                        # TODO: make this dynamic
        db_connection                       = "host=localhost port=5432 user=${var.a_rds.username} password=${var.a_rds.password} dbname=products sslmode=disable" # TODO: Use vault dynamic credentials instead
      }
    }
    public_api = {
      template_path = "${path.module}/templates/hashicups/public-api"
      app_vars = {
        public_api_hashicups_service_name   = "public-api"
        frontend_namespace                  = var.a_eks_namespace
        product_api_upstream_consul_address = "product-api.svc.default.ns.a-479598235523.ap:9090"
        payments_upstream_consul_address    = "payments.svc.default.ns.a-479598235523.ap:1800"
      }
    }
    frontend = {
      template_path = "${path.module}/templates/hashicups/frontend"
      app_vars = {
        frontend_hashicups_service_name    = "hashicups-frontend"
        frontend_namespace                 = var.a_eks_namespace
        public_api_upstream_consul_address = "public-api.svc.default.ns.a-479598235523.ap:8080"
      }
    }

    nginx = {
      template_path = "${path.module}/templates/hashicups/nginx"
      app_vars = {
        nginx_hashicups_service_name       = "nginx"
        frontend_namespace                 = var.a_eks_namespace
        public_api_upstream_consul_address = "public-api.svc.default.ns.a-479598235523.ap:8080"
        frontend_upstream_consul_address   = "hashicups-frontend.svc.default.ns.a-479598235523.ap:3000"
      }
    }

    payments = {
      template_path = "${path.module}/templates/hashicups/payments"
      app_vars = {
        payments_hashicups_service_name = "payments"
        frontend_namespace              = var.a_eks_namespace
      }
    }
  }
}
