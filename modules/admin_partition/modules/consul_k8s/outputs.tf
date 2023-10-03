output "consul_security_group" {
  description = "Security Group ID for Consul Pods"
  value       = aws_security_group.consul.id
}

output "consul_admin_partition" {
  description = "Admin partition name"
  value       = var.admin_partition_enabled ? consul_admin_partition.main[0].name : ""
}

output "consul_bootstrap_token" {
  description = "Bootstrap token for the cluster"
  value       = local.bootstrap_token
  sensitive   = true
}
