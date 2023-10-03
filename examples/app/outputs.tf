output "ingress_gateway_endpoint" {
  description = "Ingress gateway endpoint"
  value       = data.kubernetes_service.a_ingress_gateway.status[0].load_balancer[0].ingress[0].hostname
}

output "a_postgres_connection_url" {
  description = "Connection URL for Postgres"
  value       = module.app.a_postgres_connection_url
}
