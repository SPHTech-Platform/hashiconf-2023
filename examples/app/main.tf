module "app" {
  source = "../../modules/app"

  providers = {
    aws.a = aws.a
    aws.b = aws.b

    kubernetes.a = kubernetes.a
    kubernetes.b = kubernetes.b
  }

  a_rds = {
    host = data.kubernetes_service.a_ingress_gateway.status[0].load_balancer[0].ingress[0].hostname
    port = 5432

    username = local.a_rds_root.username
    password = local.a_rds_root.password
  }
}


locals {
  a_rds_root = jsondecode(data.aws_secretsmanager_secret_version.a_rds_password.secret_string)
}
