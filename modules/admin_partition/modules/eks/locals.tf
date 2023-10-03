locals {
  create_eks = var.cluster_mode == "EKS" && var.create_cluster
}
