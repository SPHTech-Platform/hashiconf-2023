variable "consul_addr" {
  description = "Address of Consul Servers"
  type        = list(string)

  validation {
    condition     = length(var.consul_addr) > 0
    error_message = "consul_addr must be a non-empty list"
  }

  validation {
    condition     = alltrue([for addr in var.consul_addr : !startswith(addr, "http://") && !startswith(addr, "https://")])
    error_message = "consul_addr must not start with http:// or https://"
  }
}

variable "consul_public_addr" {
  description = "Consul public endpoint for HTTP API"
  type        = string
}

variable "consul_chart_version" {
  description = "Consul Chart version"
  type        = string
  default     = "1.2.1"
}

variable "consul_image_tag" {
  description = "Docker image tag of Consul to run"
  type        = string
  default     = "1.16.1-ent"
}

#######
# A
#######
variable "a_cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "consul-a"
}

variable "a_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "a_private_subnets" {
  description = "Private non-routeable Subnets List"
  type        = list(string)
}

variable "a_routeable_subnets" {
  description = "Private routeable Subnets List"
  type        = list(string)
}

# Note: HCP Consul needs to be able to communicate back to K8S so this has to be enabled
variable "a_cluster_endpoint_public_access" {
  description = "Enable public access to EKS Control plane"
  type        = bool
  default     = true
}

# Note: HCP Consul needs to be able to communicate back to K8S so this has to be basically everyone
variable "a_cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "a_eks_role_mapping" {
  description = "EKS IAM Role Mapping"
  type        = list(any)
  default     = []
}

variable "a_eks_namespace" {
  description = "EKS namespace for the frontend in account A"
  type        = string
  default     = "frontend"
}

variable "a_rds_address" {
  description = "Address of RDS for Account A"
  type        = string
}

variable "a_terminating_gateway" {
  description = "Name of Terminating Gateway"
  type        = string
  default     = "terminating-gateway"
}

variable "a_ingress_gateway" {
  description = "Name of Ingress Gateway"
  type        = string
  default     = "ingress-gateway"
}

#######
# B
#######
variable "b_cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "consul-b"
}

variable "b_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "b_private_subnets" {
  description = "Private non-routeable Subnets List"
  type        = list(string)
}

variable "b_routeable_subnets" {
  description = "Private routeable Subnets List"
  type        = list(string)
}

# Note: HCP Consul needs to be able to communicate back to K8S so this has to be enabled
variable "b_cluster_endpoint_public_access" {
  description = "Enable public access to EKS Control plane"
  type        = bool
  default     = true
}

# Note: HCP Consul needs to be able to communicate back to K8S so this has to be basically everyone
variable "b_cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "b_eks_role_mapping" {
  description = "EKS IAM Role Mapping"
  type        = list(any)
  default     = []
}

variable "b_eks_namespace" {
  description = "EKS namespace for the backend in account B"
  type        = string
  default     = "backend"
}
