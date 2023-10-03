output "cluster_name" {
  description = "EKS Cluster name created"
  value       = local.create_eks ? module.eks[0].cluster_name : ""
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = local.create_eks ? module.eks[0].cluster_arn : ""
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = local.create_eks ? module.eks[0].cluster_endpoint : ""
}

output "cluster_certificate_authority_data" {
  description = "Base64 Encoded Cluster CA Data"
  value       = local.create_eks ? module.eks[0].cluster_certificate_authority_data : ""
}
