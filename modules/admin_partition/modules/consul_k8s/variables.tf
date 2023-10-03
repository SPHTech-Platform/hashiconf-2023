variable "cluster_name" {
  description = "Name of EKS Cluster"
  type        = string
}

variable "kubermetes_labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    "app.kubernetes.io/managed-by" = "terraform"
  }
}

variable "release_name" {
  description = "Helm release name for Consul"
  type        = string
  default     = "consul"
}

variable "chart_name" {
  description = "Helm chart name to provision"
  type        = string
  default     = "consul"
}

variable "chart_repository" {
  description = "Helm repository for the chart"
  type        = string
  default     = "https://helm.releases.hashicorp.com"
}

variable "chart_version" {
  description = "Version of Chart to install. Set to empty to install the latest version"
  type        = string
  default     = "1.1.2"
}

variable "consul_namespace" {
  description = "Namespace to install the chart into."
  type        = string
  default     = "consul"
}

variable "create_namespace" {
  description = "Create the namespace if it does not yet exist."
  type        = bool
  default     = false
}

variable "datacenter" {
  description = "The name of the datacenter that the agents should register as."
  type        = string
  default     = "aws-ap-southeast-1"
}

variable "log_level" {
  description = "The default log level to apply to all components."
  type        = string
  default     = "info"
}

variable "consul_image_name" {
  description = "Docker Image of Consul to run"
  type        = string
  default     = "hashicorp/consul-enterprise"
}

variable "consul_image_tag" {
  description = "Docker image tag of Consul to run"
  type        = string
  default     = "1.15.3-ent"
}

variable "admin_partition_enabled" {
  description = "Enable admin partition."
  type        = bool
  default     = true
}

variable "partition_prefix" {
  description = "Prefix for admin partition name."
  type        = string
  default     = "partition"
}

variable "consul_bootstrap_token" {
  description = "Consul Bootstrap token. If not provided, one will be created."
  type        = string
  sensitive   = true
  default     = ""
}

variable "k8s_auth_host" {
  description = "K8S Auth Host."
  type        = string
}

variable "envoy_extra_args" {
  description = <<-EOF
    Used to pass arguments to the injected envoy sidecar.
    Valid arguments to pass to envoy can be found here: https://www.envoyproxy.io/docs/envoy/latest/operations/cli
    e.g: "--component-log-level upstream:debug,http:debug,router:debug,config:debug"
    EOF
  type        = string
  default     = null
}

variable "external_servers" {
  description = "Consul external servers."
  type        = list(string)

  validation {
    condition     = length(var.external_servers) > 0
    error_message = "external_servers must be a non-empty list"
  }

  validation {
    condition     = alltrue([for addr in var.external_servers : !startswith(addr, "http://") && !startswith(addr, "https://")])
    error_message = "external_servers must not start with http:// or https://"
  }
}

variable "extra_labels" {
  description = "Extra labels to attach to all pods, deployments, daemonsets, statefulsets, and jobs."
  type        = map(string)
  default     = {}
}

variable "ingress_gateway_enabled" {
  description = "Enable ingress gateway deployment. equires connectInject.enabled=true."
  type        = bool
  default     = false
}

variable "ingress_gateway_replicas" {
  description = "Number of replicas for each ingress gateway defined."
  type        = number
  default     = 2
}

variable "ingress_gateway_service_type" {
  description = "Type of service, ex. LoadBalancer, ClusterIP."
  type        = string
  default     = "LoadBalancer"
}

variable "ingress_gateway_annotations" {
  description = "Annotations to apply to the ingress gateway service."
  type        = map(string)
  default = {
    "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internal"
    "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
  }
}

variable "ingress_gateway_service_ports" {
  description = "Ports that will be exposed on the service and gateway container. Any ports defined as ingress listeners on the gateway's Consul configuration entry should be included here."
  type = list(object({
    port     = number
    nodePort = number
  }))
  default = [
    {
      port     = 8080
      nodePort = null
    },
    {
      port     = 8443
      nodePort = null
    },
  ]
}

variable "ingress_gateway_security_group_ids" {
  description = "The frontend securityGroups you want to attach to Ingress gateway NLB."
  type        = list(string)
  default     = []
}

variable "ingress_gateway_subnet_ids" {
  description = "Subnets (name or id) of Ingress gateway NLB. Subnets are auto-discovered if it's empty."
  type        = list(string)
  default     = []
}

variable "mesh_gateway_enabled" {
  description = "Enable mesh gateway."
  type        = bool
  default     = false
}

variable "mesh_gateway_replicas" {
  description = "Number of replicas for the Deployment."
  type        = number
  default     = 2
}

variable "mesh_gateway_wan_address_source" {
  description = "Source configures where to retrieve the WAN address for the mesh gateway from. Ex Service, NodeIP, NodeName or Static"
  type        = string
  default     = "ClusterIP"
}

variable "mesh_gateway_wan_address_port" {
  description = "Port that gets registered for WAN traffic. If mesh_gateway_wan_address_source is set to Service then this setting will have no effect"
  type        = number
  default     = 8443
}

variable "mesh_gateway_service_type" {
  description = "Type of service, ex. LoadBalancer, ClusterIP."
  type        = string
  default     = "ClusterIP"
}

variable "mesh_gateway_service_port" {
  description = "Port that the service will be exposed on. The targetPort will be set to meshGateway.containerPort.."
  type        = number
  default     = 443
}

variable "mesh_gateway_annotations" {
  description = "Annotations to apply to the mesh gateway service"
  type        = map(string)
  default     = {}
}

variable "mesh_gateway_container_port" {
  description = "Port that the gateway will run on inside the container."
  type        = number
  default     = 8443
}

variable "consul_security_group" {
  description = "Name of Security Group for Consul pods"
  type        = string
  default     = "consul-k8s"
}

variable "consul_security_group_ingress_sg" {
  description = "List of security groups to allow ingress from Consul Pods"
  type        = map(string) # Key does not matter
  default     = {}
}

variable "dns_enabled" {
  description = "Enable DNS configuration within Kubernetes Cluster."
  type        = bool
  default     = false
}

variable "dns_enable_redirection" {
  description = "If true, services using Consul service mesh will use Consul DNS for default DNS resolution."
  type        = bool
  default     = false
}

variable "dns_cluster_ip" {
  description = "Set a predefined cluster IP for the DNS service."
  type        = string
  default     = "172.20.0.200"
}
