output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "default_network_acl_id" {
  description = "Default ACL ID"
  value       = module.vpc.default_network_acl_id
}

output "public_subnets" {
  description = "Public Subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private Subnets"
  value       = module.vpc.private_subnets
}

output "database_subnet_group" {
  description = "Database Subnet group"
  value       = aws_db_subnet_group.database.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}
