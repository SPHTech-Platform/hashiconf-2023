variable "create_cluster" {
  description = "Create the cluster."
  type        = bool
  default     = true
}

variable "cluster_mode" {
  description = "Cluster Mode, ECS or EKS."
  type        = string
  default     = "EKS"
  validation {
    condition     = contains(["EKS"], var.cluster_mode)
    error_message = "Invalid cluster_mode, only EKS supported."
  }
}

variable "skip_asg_role" {
  description = "Skip creating ASG Service Linked Role if it's already created"
  type        = bool
  default     = true
}

variable "role_mapping" {
  description = "List of IAM roles to give access to the EKS cluster"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_additional_security_group_ids" {
  description = "List of additional, externally created security group IDs to attach to the cluster control plane"
  type        = list(string)
  default     = []
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "create_aws_auth_configmap" {
  description = "Determines whether to create the aws-auth configmap. NOTE - this is only intended for scenarios where the configmap does not exist (i.e. - when using only self-managed node groups). Most users should use `manage_aws_auth_configmap`"
  type        = bool
  default     = false
}

variable "manage_aws_auth_configmap" {
  description = "Determines whether to manage the contents of the aws-auth configmap"
  type        = bool
  default     = true
}

variable "create_cluster_security_group" {
  description = "Determines if a security group is created for the cluster. Note: the EKS service creates a primary security group for the cluster by default"
  type        = bool
  default     = false
}

variable "create_node_security_group" {
  description = "Determines whether to create a security group for the node groups or use the existing `node_security_group_id`"
  type        = bool
  default     = false
}

##############
# EKS Fargate
##############
variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "hcp-consul-client"
}

variable "cluster_version" {
  description = "EKS Cluster version"
  type        = string
  default     = "1.27"
}

variable "vpc_id" {
  description = "VPC ID to deploy the cluster into"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS kube-system, default and essential fargate profiles will be provisioned."
  type        = list(string)
}

variable "consul_subnet_ids" {
  description = "A list of subnet IDs where the EKS consul profile will be provisioned."
  type        = list(string)
}

variable "aws_auth_fargate_profile_pod_execution_role_arns" {
  description = "List of Fargate profile pod execution role ARNs to add to the aws-auth configmap"
  type        = list(string)
  default     = []
}

################
# LB Controller
################
variable "lb_controller_chart_version" {
  description = "LB Controller chart version"
  type        = string
  default     = "1.6.0"
}

variable "lb_controller_image_tag" {
  description = "LB Controller image tag"
  type        = string
  default     = "v2.6.0"
}
