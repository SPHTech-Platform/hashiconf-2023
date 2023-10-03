resource "aws_security_group" "consul" {
  #checkov:skip=CKV2_AWS_5:SG is used by EKS
  name        = var.consul_security_group
  description = "Consul K8S Pods"
  vpc_id      = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id

  tags = {
    Name = var.consul_security_group
  }
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.consul.id
  description       = "Allow all egress traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_from_control_plane" {
  security_group_id = aws_security_group.consul.id
  description       = "Allow all ingress traffic from control plane"
  ip_protocol       = "-1"

  referenced_security_group_id = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_from_itself" {
  security_group_id = aws_security_group.consul.id
  description       = "Allow all ingress from itself"
  ip_protocol       = "-1"

  referenced_security_group_id = aws_security_group.consul.id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_from_consul" {
  for_each = merge(
    {
      cluster = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
    },
    var.consul_security_group_ingress_sg,
  )

  security_group_id = each.value

  description = "Allow ingress traffic from Consul Pods"
  ip_protocol = "-1"

  referenced_security_group_id = aws_security_group.consul.id
}

resource "kubernetes_manifest" "consul_security_group" {
  manifest = {
    apiVersion = "vpcresources.k8s.aws/v1beta1"
    kind       = "SecurityGroupPolicy"
    metadata = {
      name      = var.consul_security_group
      namespace = kubernetes_namespace.consul.id
      labels    = var.kubermetes_labels
    }
    spec = {
      podSelector = {
        matchLabels = {
          app     = "consul"
          release = var.release_name
        }
      }
      securityGroups = {
        groupIds = [aws_security_group.consul.id]
      }
    }
  }
}
