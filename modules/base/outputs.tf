#########
# consul
#########

output "consul_cluster_id" {
  description = "Consul Cluster ID"
  value       = hcp_consul_cluster.this.cluster_id
}

output "consul_version" {
  description = "Consul Version"
  value       = hcp_consul_cluster.this.consul_version
}

output "consul_datacenter" {
  description = "Consul Datacenter"
  value       = hcp_consul_cluster.this.datacenter
}

output "consul_private_url" {
  description = "Private URL for Consul  cluster"
  value       = hcp_consul_cluster.this.consul_private_endpoint_url
}

output "consul_public_url" {
  description = "Public URL for Consul  cluster"
  value       = hcp_consul_cluster.this.consul_public_endpoint_url
}

output "consul_ca" {
  description = "The cluster CA file encoded as a Base64 string."
  value       = hcp_consul_cluster.this.consul_ca_file
}

output "consul_config_file" {
  description = "The cluster config encoded as a Base64 string."
  value       = hcp_consul_cluster.this.consul_config_file
}

output "consul_root_token_secret_id" {
  description = "Consul Root Token during cluster creation"
  value       = hcp_consul_cluster.this.consul_root_token_secret_id
  sensitive   = true
}

#######
# Vault
#######
output "vault_private_endpoint_url" {
  description = "Private URL for Vault cluster"
  value       = hcp_vault_cluster.this.vault_private_endpoint_url
}

output "vault_public_endpoint_url" {
  description = "Public URL for Vault cluster"
  value       = hcp_vault_cluster.this.vault_public_endpoint_url
}

output "vault_cluster_id" {
  description = "Cluster ID for Vault cluster"
  value       = hcp_vault_cluster.this.cluster_id
}

#######
# A
#######
output "a_vpc_id" {
  description = "VPC ID"
  value       = module.a_vpc.vpc_id
}

output "a_private_subnets" {
  description = "Private Subnets"
  value       = module.a_vpc.private_subnets
}

output "a_public_subnets" {
  description = "public Subnets"
  value       = module.a_vpc.public_subnets
}

output "a_routeable_subnets" {
  description = "Routeable Subnets"
  value       = module.a_routeable.routeable_subnets
}

output "a_rds_address" {
  description = "Address of RDS"
  value       = module.rds_a.cluster_endpoint
}

output "a_rds_username" {
  description = "Address of RDS"
  sensitive   = true
  value       = module.rds_a.cluster_master_username
}

output "a_rds_password" {
  description = "Address of RDS"
  sensitive   = true
  value       = module.rds_a.cluster_master_user_secret
}

#######
# B
#######
output "b_vpc_id" {
  description = "VPC ID"
  value       = module.b_vpc.vpc_id
}

output "b_private_subnets" {
  description = "Private Subnets"
  value       = module.b_vpc.private_subnets
}

output "b_public_subnets" {
  description = "public Subnets"
  value       = module.b_vpc.public_subnets
}

output "b_routeable_subnets" {
  description = "Routeable Subnets"
  value       = module.b_routeable.routeable_subnets
}
