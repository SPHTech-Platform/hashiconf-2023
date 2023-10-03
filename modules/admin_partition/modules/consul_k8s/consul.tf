locals {
  create_acl_token = var.consul_bootstrap_token == null || var.consul_bootstrap_token == ""
  bootstrap_token  = local.create_acl_token ? data.consul_acl_token_secret_id.bootstrap[0].secret_id : var.consul_bootstrap_token
}

resource "consul_admin_partition" "main" {
  count = var.admin_partition_enabled ? 1 : 0

  name        = "${var.partition_prefix}-${data.aws_caller_identity.current.account_id}"
  description = "Partition for AWS account \"${data.aws_caller_identity.current.account_id}\""
}

resource "consul_acl_token" "bootstrap" {
  count = local.create_acl_token ? 1 : 0

  description = var.admin_partition_enabled ? "Bootstrap for Consul K8S for Admin Partition ${consul_admin_partition.main[0].name}" : "Bootstrap for Consul K8S"

  policies = var.admin_partition_enabled ? [consul_acl_policy.bootstrap[0].name] : ["global-management"]
}

resource "consul_acl_policy" "bootstrap" {
  count = local.create_acl_token && var.admin_partition_enabled ? 1 : 0

  name        = "${consul_admin_partition.main[0].name}-bootstrap"
  description = "Bootstrap for Consul K8S for Admin Partition ${consul_admin_partition.main[0].name}}"

  partition = "default"

  rules = templatefile("${path.module}/templates/bootstrap.hcl", {
    partition = consul_admin_partition.main[0].name
  })
}

data "consul_acl_token_secret_id" "bootstrap" {
  count = local.create_acl_token ? 1 : 0

  accessor_id = consul_acl_token.bootstrap[0].id
}
