variable "azs_count" {
  description = "Number of AZs to create subnets for"
  type        = number
  default     = 3
}

variable "routeable_subnets_cidr" {
  description = "Routeable CIDR for subnets"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "network_acl_id" {
  description = "NACL ID for Routeable Subnets"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet IDs"
  type        = set(string)
}

variable "private_subnets" {
  description = "Private subnet IDs"
  type        = set(string)
}

variable "routeable_cidr" {
  description = "Routeable CIDR for the entire TGW network"
  type        = set(string)
  default     = ["10.128.0.0/9"]
}

variable "tgw_id" {
  description = "ID of Transit Gateway"
  type        = string
}
