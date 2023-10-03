# Terraform Modules Template

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.4 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.11 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | SPHTech-Platform/eks/aws | ~> 0.16.0 |
| <a name="module_lb_controller"></a> [lb\_controller](#module\_lb\_controller) | SPHTech-Platform/lb-controller/aws | ~> 0.7.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_auth_fargate_profile_pod_execution_role_arns"></a> [aws\_auth\_fargate\_profile\_pod\_execution\_role\_arns](#input\_aws\_auth\_fargate\_profile\_pod\_execution\_role\_arns) | List of Fargate profile pod execution role ARNs to add to the aws-auth configmap | `list(string)` | `[]` | no |
| <a name="input_cluster_additional_security_group_ids"></a> [cluster\_additional\_security\_group\_ids](#input\_cluster\_additional\_security\_group\_ids) | List of additional, externally created security group IDs to attach to the cluster control plane | `list(string)` | `[]` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS public API server endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_mode"></a> [cluster\_mode](#input\_cluster\_mode) | Cluster Mode, ECS or EKS. | `string` | `"EKS"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | `"hcp-consul-client"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | EKS Cluster version | `string` | `"1.27"` | no |
| <a name="input_consul_subnet_ids"></a> [consul\_subnet\_ids](#input\_consul\_subnet\_ids) | A list of subnet IDs where the EKS consul profile will be provisioned. | `list(string)` | n/a | yes |
| <a name="input_create_aws_auth_configmap"></a> [create\_aws\_auth\_configmap](#input\_create\_aws\_auth\_configmap) | Determines whether to create the aws-auth configmap. NOTE - this is only intended for scenarios where the configmap does not exist (i.e. - when using only self-managed node groups). Most users should use `manage_aws_auth_configmap` | `bool` | `false` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Create the cluster. | `bool` | `true` | no |
| <a name="input_create_cluster_security_group"></a> [create\_cluster\_security\_group](#input\_create\_cluster\_security\_group) | Determines if a security group is created for the cluster. Note: the EKS service creates a primary security group for the cluster by default | `bool` | `false` | no |
| <a name="input_create_node_security_group"></a> [create\_node\_security\_group](#input\_create\_node\_security\_group) | Determines whether to create a security group for the node groups or use the existing `node_security_group_id` | `bool` | `false` | no |
| <a name="input_lb_controller_chart_version"></a> [lb\_controller\_chart\_version](#input\_lb\_controller\_chart\_version) | LB Controller chart version | `string` | `"1.6.0"` | no |
| <a name="input_lb_controller_image_tag"></a> [lb\_controller\_image\_tag](#input\_lb\_controller\_image\_tag) | LB Controller image tag | `string` | `"v2.6.0"` | no |
| <a name="input_manage_aws_auth_configmap"></a> [manage\_aws\_auth\_configmap](#input\_manage\_aws\_auth\_configmap) | Determines whether to manage the contents of the aws-auth configmap | `bool` | `true` | no |
| <a name="input_role_mapping"></a> [role\_mapping](#input\_role\_mapping) | List of IAM roles to give access to the EKS cluster | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_skip_asg_role"></a> [skip\_asg\_role](#input\_skip\_asg\_role) | Skip creating ASG Service Linked Role if it's already created | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs where the EKS kube-system, default and essential fargate profiles will be provisioned. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to deploy the cluster into | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The ARN of the EKS cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 Encoded Cluster CA Data |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint of the EKS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS Cluster name created |
<!-- END_TF_DOCS -->
