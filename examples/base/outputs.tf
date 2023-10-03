output "consul_cluster_id" {
  description = "Consul Cluster ID"
  value       = module.base.consul_cluster_id
}

output "consul_version" {
  description = "Consul Version"
  value       = module.base.consul_version
}

output "consul_datacenter" {
  description = "Consul Datacenter"
  value       = module.base.consul_datacenter
}

output "consul_private_url" {
  description = "Private URL for Consul cluster"
  value       = module.base.consul_private_url
}

output "consul_public_url" {
  description = "Public URL for Consul cluster"
  value       = module.base.consul_public_url
}

output "consul_ca" {
  description = "The cluster CA file encoded as a Base64 string."
  value       = module.base.consul_ca
}

output "consul_config_file" {
  description = "The cluster config encoded as a Base64 string."
  value       = module.base.consul_config_file
}

output "consul_root_token_secret_id" {
  description = "Consul Root Token during cluster creation"
  value       = module.base.consul_root_token_secret_id
  sensitive   = true
}

output "vault_private_endpoint_url" {
  description = "Private URL for Vault cluster"
  value       = module.base.vault_private_endpoint_url
}

output "vault_public_endpoint_url" {
  description = "Public URL for Vault cluster"
  value       = module.base.vault_public_endpoint_url
}

output "vault_cluster_id" {
  description = "Cluster ID for Vault cluster"
  value       = module.base.vault_cluster_id
}

#######
# A
#######
output "a_vpc_id" {
  description = "VPC ID"
  value       = module.base.a_vpc_id
}

output "a_private_subnets" {
  description = "Private Subnets"
  value       = module.base.a_private_subnets
}

output "a_public_subnets" {
  description = "public Subnets"
  value       = module.base.a_public_subnets
}

output "a_routeable_subnets" {
  description = "Routeable Subnets"
  value       = module.base.a_routeable_subnets
}

output "a_rds_address" {
  description = "Address of RDS"
  value       = module.base.a_rds_address
}

output "a_rds_username" {
  description = "username of RDS"
  sensitive   = true
  value       = module.base.a_rds_username
}

output "a_rds_password" {
  description = "password of RDS"
  value       = module.base.a_rds_password
  sensitive   = true
}

#######
# B
#######
output "b_vpc_id" {
  description = "VPC ID"
  value       = module.base.b_vpc_id
}

output "b_private_subnets" {
  description = "Private Subnets"
  value       = module.base.b_private_subnets
}

output "b_public_subnets" {
  description = "public Subnets"
  value       = module.base.b_public_subnets
}

output "b_routeable_subnets" {
  description = "Routeable Subnets"
  value       = module.base.b_routeable_subnets
}
