variable "name" {
  description = "Name of VPC"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
  type        = list(string)
  default     = []
}

variable "azs_count" {
  description = "Number of AZs to create subnets for"
  type        = number
  default     = 3
}

variable "add_subnet_autodiscovery_annotations" {
  description = "Add subnet autodiscovery annotations"
  type        = bool
  default     = false
}
