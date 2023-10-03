variable "a_eks_namespace" {
  description = "EKS namespace for the frontend in account A. This will be used as consul namespace as well where the app will be registered"
  type        = string
  default     = "frontend"
}

variable "a_service_name" {
  description = "value of the service name in account A."
  type        = string
  default     = "frontend"
}

variable "a_vault_namespace" {
  description = "Vault Namespace to use for account A"
  type        = string
  default     = null
}

variable "a_vault_database_mount" {
  description = "Mount path of the database secrets engine"
  type        = string
  default     = "postgres"
}

variable "a_vault_database_role" {
  description = "Name of the Database Secrets Role to create"
  type        = string
  default     = "dev"
}

variable "a_rds" {
  description = "RDS Settings"
  type = object({
    host     = string
    username = string
    password = string

    port     = optional(number, 5432)
    database = optional(string, "postgres")
  })
  sensitive = true
}

variable "b_eks_namespace" {
  description = "EKS namespace for the backend in account B. This will be used as consul namespace as well where the app will be registered"
  type        = string
  default     = "backend"
}

variable "b_service_name" {
  description = "value of the service name in account B"
  type        = string
  default     = "backend"
}

variable "expose_backend_to_frontend" {
  description = "Expose backend to frontend"
  type        = bool
  default     = true
}
