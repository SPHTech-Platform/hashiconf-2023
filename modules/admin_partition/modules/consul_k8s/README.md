<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | >= 2.17 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.21 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_consul"></a> [consul](#provider\_consul) | >= 2.17 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.21 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_from_consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_from_control_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.ingress_from_itself](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [consul_acl_policy.bootstrap](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_policy) | resource |
| [consul_acl_token.bootstrap](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_token) | resource |
| [consul_admin_partition.main](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/admin_partition) | resource |
| [helm_release.consul_client](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.consul_security_group](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.consul](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret_v1.bootstrap_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [consul_acl_token_secret_id.bootstrap](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/data-sources/acl_token_secret_id) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_partition_enabled"></a> [admin\_partition\_enabled](#input\_admin\_partition\_enabled) | Enable admin partition. | `bool` | `true` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name to provision | `string` | `"consul"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm repository for the chart | `string` | `"https://helm.releases.hashicorp.com"` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Chart to install. Set to empty to install the latest version | `string` | `"1.1.2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of EKS Cluster | `string` | n/a | yes |
| <a name="input_consul_bootstrap_token"></a> [consul\_bootstrap\_token](#input\_consul\_bootstrap\_token) | Consul Bootstrap token. If not provided, one will be created. | `string` | `""` | no |
| <a name="input_consul_image_name"></a> [consul\_image\_name](#input\_consul\_image\_name) | Docker Image of Consul to run | `string` | `"hashicorp/consul-enterprise"` | no |
| <a name="input_consul_image_tag"></a> [consul\_image\_tag](#input\_consul\_image\_tag) | Docker image tag of Consul to run | `string` | `"1.15.3-ent"` | no |
| <a name="input_consul_namespace"></a> [consul\_namespace](#input\_consul\_namespace) | Namespace to install the chart into. | `string` | `"consul"` | no |
| <a name="input_consul_security_group"></a> [consul\_security\_group](#input\_consul\_security\_group) | Name of Security Group for Consul pods | `string` | `"consul-k8s"` | no |
| <a name="input_consul_security_group_ingress_sg"></a> [consul\_security\_group\_ingress\_sg](#input\_consul\_security\_group\_ingress\_sg) | List of security groups to allow ingress from Consul Pods | `map(string)` | `{}` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not yet exist. | `bool` | `false` | no |
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | The name of the datacenter that the agents should register as. | `string` | `"aws-ap-southeast-1"` | no |
| <a name="input_dns_cluster_ip"></a> [dns\_cluster\_ip](#input\_dns\_cluster\_ip) | Set a predefined cluster IP for the DNS service. | `string` | `"172.20.0.200"` | no |
| <a name="input_dns_enable_redirection"></a> [dns\_enable\_redirection](#input\_dns\_enable\_redirection) | If true, services using Consul service mesh will use Consul DNS for default DNS resolution. | `bool` | `false` | no |
| <a name="input_dns_enabled"></a> [dns\_enabled](#input\_dns\_enabled) | Enable DNS configuration within Kubernetes Cluster. | `bool` | `false` | no |
| <a name="input_envoy_extra_args"></a> [envoy\_extra\_args](#input\_envoy\_extra\_args) | Used to pass arguments to the injected envoy sidecar.<br>Valid arguments to pass to envoy can be found here: https://www.envoyproxy.io/docs/envoy/latest/operations/cli<br>e.g: "--component-log-level upstream:debug,http:debug,router:debug,config:debug" | `string` | `null` | no |
| <a name="input_external_servers"></a> [external\_servers](#input\_external\_servers) | Consul external servers. | `list(string)` | n/a | yes |
| <a name="input_extra_labels"></a> [extra\_labels](#input\_extra\_labels) | Extra labels to attach to all pods, deployments, daemonsets, statefulsets, and jobs. | `map(string)` | `{}` | no |
| <a name="input_ingress_gateway_annotations"></a> [ingress\_gateway\_annotations](#input\_ingress\_gateway\_annotations) | Annotations to apply to the ingress gateway service. | `map(string)` | <pre>{<br>  "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type": "ip",<br>  "service.beta.kubernetes.io/aws-load-balancer-scheme": "internal"<br>}</pre> | no |
| <a name="input_ingress_gateway_enabled"></a> [ingress\_gateway\_enabled](#input\_ingress\_gateway\_enabled) | Enable ingress gateway deployment. equires connectInject.enabled=true. | `bool` | `false` | no |
| <a name="input_ingress_gateway_replicas"></a> [ingress\_gateway\_replicas](#input\_ingress\_gateway\_replicas) | Number of replicas for each ingress gateway defined. | `number` | `2` | no |
| <a name="input_ingress_gateway_security_group_ids"></a> [ingress\_gateway\_security\_group\_ids](#input\_ingress\_gateway\_security\_group\_ids) | The frontend securityGroups you want to attach to Ingress gateway NLB. | `list(string)` | `[]` | no |
| <a name="input_ingress_gateway_service_ports"></a> [ingress\_gateway\_service\_ports](#input\_ingress\_gateway\_service\_ports) | Ports that will be exposed on the service and gateway container. Any ports defined as ingress listeners on the gateway's Consul configuration entry should be included here. | <pre>list(object({<br>    port     = number<br>    nodePort = number<br>  }))</pre> | <pre>[<br>  {<br>    "nodePort": null,<br>    "port": 8080<br>  },<br>  {<br>    "nodePort": null,<br>    "port": 8443<br>  }<br>]</pre> | no |
| <a name="input_ingress_gateway_service_type"></a> [ingress\_gateway\_service\_type](#input\_ingress\_gateway\_service\_type) | Type of service, ex. LoadBalancer, ClusterIP. | `string` | `"LoadBalancer"` | no |
| <a name="input_ingress_gateway_subnet_ids"></a> [ingress\_gateway\_subnet\_ids](#input\_ingress\_gateway\_subnet\_ids) | Subnets (name or id) of Ingress gateway NLB. Subnets are auto-discovered if it's empty. | `list(string)` | `[]` | no |
| <a name="input_k8s_auth_host"></a> [k8s\_auth\_host](#input\_k8s\_auth\_host) | K8S Auth Host. | `string` | n/a | yes |
| <a name="input_kubermetes_labels"></a> [kubermetes\_labels](#input\_kubermetes\_labels) | Labels to apply to all resources | `map(string)` | <pre>{<br>  "app.kubernetes.io/managed-by": "terraform"<br>}</pre> | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | The default log level to apply to all components. | `string` | `"info"` | no |
| <a name="input_mesh_gateway_annotations"></a> [mesh\_gateway\_annotations](#input\_mesh\_gateway\_annotations) | Annotations to apply to the mesh gateway service | `map(string)` | `{}` | no |
| <a name="input_mesh_gateway_container_port"></a> [mesh\_gateway\_container\_port](#input\_mesh\_gateway\_container\_port) | Port that the gateway will run on inside the container. | `number` | `8443` | no |
| <a name="input_mesh_gateway_enabled"></a> [mesh\_gateway\_enabled](#input\_mesh\_gateway\_enabled) | Enable mesh gateway. | `bool` | `false` | no |
| <a name="input_mesh_gateway_replicas"></a> [mesh\_gateway\_replicas](#input\_mesh\_gateway\_replicas) | Number of replicas for the Deployment. | `number` | `2` | no |
| <a name="input_mesh_gateway_service_port"></a> [mesh\_gateway\_service\_port](#input\_mesh\_gateway\_service\_port) | Port that the service will be exposed on. The targetPort will be set to meshGateway.containerPort.. | `number` | `443` | no |
| <a name="input_mesh_gateway_service_type"></a> [mesh\_gateway\_service\_type](#input\_mesh\_gateway\_service\_type) | Type of service, ex. LoadBalancer, ClusterIP. | `string` | `"ClusterIP"` | no |
| <a name="input_mesh_gateway_wan_address_port"></a> [mesh\_gateway\_wan\_address\_port](#input\_mesh\_gateway\_wan\_address\_port) | Port that gets registered for WAN traffic. If mesh\_gateway\_wan\_address\_source is set to Service then this setting will have no effect | `number` | `8443` | no |
| <a name="input_mesh_gateway_wan_address_source"></a> [mesh\_gateway\_wan\_address\_source](#input\_mesh\_gateway\_wan\_address\_source) | Source configures where to retrieve the WAN address for the mesh gateway from. Ex Service, NodeIP, NodeName or Static | `string` | `"ClusterIP"` | no |
| <a name="input_partition_prefix"></a> [partition\_prefix](#input\_partition\_prefix) | Prefix for admin partition name. | `string` | `"partition"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name for Consul | `string` | `"consul"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consul_admin_partition"></a> [consul\_admin\_partition](#output\_consul\_admin\_partition) | Admin partition name |
| <a name="output_consul_bootstrap_token"></a> [consul\_bootstrap\_token](#output\_consul\_bootstrap\_token) | Bootstrap token for the cluster |
| <a name="output_consul_security_group"></a> [consul\_security\_group](#output\_consul\_security\_group) | Security Group ID for Consul Pods |
<!-- END_TF_DOCS -->
