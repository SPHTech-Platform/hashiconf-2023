variable "routeable_cidr" {
  description = "Routeable CIDR for the entire TGW network"
  type        = set(string)
  default     = ["10.128.0.0/9"]
}

######
# hvn
######
variable "hvn_id" {
  description = "The ID of the HashiCorp Virtual Network (HVN)."
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The region where the HVN is located."
  type        = string
  default     = "ap-southeast-1"
}

variable "hvn_cidr_block" {
  description = "The CIDR range of the HVN. If this is not provided, the service will provide a default value."
  type        = string
}

#########
# consul
#########
variable "consul_cluster_id" {
  description = "The ID of the HCP Consul cluster."
  type        = string
  default     = "hashiconf"
}

variable "consul_tier" {
  description = "The tier that the HCP Consul cluster will be provisioned as."
  type        = string
  default     = "development"
}

variable "consul_size" {
  description = "The t-shirt size representation of each server VM that this Consul cluster is provisioned with."
  type        = string
  default     = "x_small"
}

variable "min_consul_version" {
  description = "The minimum Consul patch version of the cluster."
  type        = string
  default     = "1.15.2"
}

variable "consul_datacenter" {
  description = "Consul Datacentre name"
  type        = string
  default     = ""
}

variable "consul_public_endpoint" {
  description = "Enable public endpoint for Consul"
  type        = bool
  default     = false
}

#########
# vault
#########
# tflint-ignore: terraform_unused_declarations
variable "vault_cluster_id" {
  description = "Name of the Vault Cluster"
  type        = string
  default     = "hashiconf"
}

#######
# TGW
#######
variable "tgw_name" {
  description = "Names of TGW resources"
  type        = string
  default     = "tgw"
}

variable "tgw_cidr" {
  description = "CIDRs of the TGW VPCs"
  type        = string
}

#######
# A
#######
variable "a_name" {
  description = "Names of a resources"
  type        = string
  default     = "a"
}

variable "a_cidr" {
  description = "CIDRs of the a VPCs"
  type        = string
  default     = "10.0.0.0/16"
}

variable "a_routeable_cidr" {
  description = "Routeable CIDR for Account A"
  type        = string
}

#######
# b
#######
variable "b_name" {
  description = "Names of b resources"
  type        = string
  default     = "b"
}

variable "b_cidr" {
  description = "CIDRs of the b VPCs"
  type        = string
  default     = "10.0.0.0/16"
}

variable "b_routeable_cidr" {
  description = "Routeable CIDR for Account B"
  type        = string
}
