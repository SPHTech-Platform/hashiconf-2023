output "a_cluster_name" {
  description = "Cluster Name"
  value       = module.consul_cluster_account_a.cluster_name
}

output "a_cluster_endpoint" {
  description = "Cluster Endpoint"
  value       = module.consul_cluster_account_a.cluster_endpoint
}


output "b_cluster_name" {
  description = "Cluster Name"
  value       = module.consul_cluster_account_b.cluster_name
}

output "b_cluster_endpoint" {
  description = "Cluster Endpoint"
  value       = module.consul_cluster_account_b.cluster_endpoint
}
