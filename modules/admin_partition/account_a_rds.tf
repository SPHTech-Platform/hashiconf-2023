locals {
  a_admin_partition_name  = module.consul_k8s_account_a.consul_admin_partition
  a_hashicups_product_api = "product-api"
}

resource "consul_node" "rds_a" {
  name      = "a-rds"
  address   = var.a_rds_address
  partition = local.a_admin_partition_name

  meta = {
    external-node  = "true"
    external-probe = "false"
  }
}

resource "consul_service" "rds_a" {
  name      = "a-rds"
  node      = consul_node.rds_a.name
  partition = local.a_admin_partition_name
  port      = 5432
  tags      = ["database"]

  meta = {
    "service" = "rds"
  }
}

resource "consul_config_entry" "terminating_gateway" {
  name      = var.a_terminating_gateway
  kind      = "terminating-gateway"
  partition = local.a_admin_partition_name
  namespace = "default"

  config_json = jsonencode({
    Services = [
      { Name = consul_service.rds_a.name },
    ]
  })
}

resource "consul_acl_policy" "a_terminating_gateway_rds" {
  name        = "${var.a_terminating_gateway}-rds"
  description = "Token Policy managed by TF"
  partition   = local.a_admin_partition_name
  rules       = <<-RULE
    partition "${local.a_admin_partition_name}" {
      namespace "default" {
        service "${var.a_terminating_gateway}" {
          policy = "write"
        }
        service "${consul_service.rds_a.name}" {
          policy = "write"
        }
        node_prefix "" {
          policy = "read"
        }
      }
    }
    RULE
}

data "consul_acl_role" "a_terminating_gateway" {
  name      = "consul-${var.a_terminating_gateway}-acl-role"
  partition = local.a_admin_partition_name
}

data "consul_acl_policy" "a_terminating_gateway" {
  name      = "${var.a_terminating_gateway}-policy"
  partition = local.a_admin_partition_name
}

# Replace with https://github.com/hashicorp/terraform-provider-consul/issues/354
resource "terracurl_request" "a_terminating_gateway" {
  name         = "update-terminating-gateway-acl-role"
  url          = "${var.consul_public_addr}/v1/acl/role/${data.consul_acl_role.a_terminating_gateway.id}?partition=${data.consul_acl_role.a_terminating_gateway.partition}"
  method       = "PUT"
  request_body = <<EOF
  {
    "Name": "${data.consul_acl_role.a_terminating_gateway.name}",
    "Policies":[
      {
        "ID": "${data.consul_acl_policy.a_terminating_gateway.id}",
        "Name": "${data.consul_acl_policy.a_terminating_gateway.name}"
      },
      {
        "ID": "${consul_acl_policy.a_terminating_gateway_rds.id}",
        "Name": "${consul_acl_policy.a_terminating_gateway_rds.name}"
      }
    ]
  }
  EOF
  headers = {
    "X-Consul-Token" = module.consul_k8s_account_a.consul_bootstrap_token
  }
  response_codes = [
    200,
  ]

  destroy_url          = "${var.consul_public_addr}/v1/acl/role/${data.consul_acl_role.a_terminating_gateway.id}?partition=${data.consul_acl_role.a_terminating_gateway.partition}"
  destroy_method       = "PUT"
  destroy_request_body = <<EOF
  {
    "Name": "${data.consul_acl_role.a_terminating_gateway.name}",
    "Policies":[
      {
        "ID": "${data.consul_acl_policy.a_terminating_gateway.id}",
        "Name": "${data.consul_acl_policy.a_terminating_gateway.name}"
      }
    ]
  }
  EOF

  destroy_headers = {
    "X-Consul-Token" = module.consul_k8s_account_a.consul_bootstrap_token
  }

  destroy_response_codes = [
    200,
  ]
}

resource "consul_config_entry" "a_ingress_gateway" {
  name      = var.a_ingress_gateway
  kind      = "ingress-gateway"
  partition = local.a_admin_partition_name

  config_json = jsonencode({
    TLS = {
      Enabled = false
    }
    Listeners = [
      {
        Port     = 5432
        Protocol = "tcp"
        Services = [
          { Name = consul_service.rds_a.name }
        ]
      },
    ]
  })
}

resource "consul_config_entry" "a_intention_ingress_gateway_to_rds_aurora" {
  kind      = "service-intentions"
  partition = local.a_admin_partition_name
  name      = consul_service.rds_a.name

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = consul_config_entry.a_ingress_gateway.name
        Partition  = local.a_admin_partition_name
        Precedence = 9
        Type       = "consul"
      },
      {
        Action     = "allow"
        Name       = local.a_hashicups_product_api
        Namespace  = var.a_eks_namespace
        Partition  = local.a_admin_partition_name
        Precedence = 10
        Type       = "consul"
      },
      {
        Action     = "allow"
        Name       = consul_config_entry.tgw_ingress_gateway.name
        Partition  = local.tgw_admin_partition_name
        Precedence = 9
        Type       = "consul"
      },
    ]
  })
}

resource "consul_config_entry" "export_rds_a" {
  kind      = "exported-services"
  name      = local.a_admin_partition_name
  partition = local.a_admin_partition_name

  config_json = jsonencode({
    Services = [
      {
        Name      = consul_service.rds_a.name
        Namespace = "default"
        Consumers = [
          {
            Partition = local.tgw_admin_partition_name
          },
        ]
      },
      {
        Name      = "mesh-gateway"
        Namespace = "default"
        Consumers = [
          {
            Partition = local.tgw_admin_partition_name
          }
        ]
      }
    ]
  })
}
