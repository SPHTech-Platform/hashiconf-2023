operator = "read"

acl = "write"

partition "default" {
  agent_prefix "" {
    policy = "read"
  }
}

partition "${partition}" {
  acl = "write"

  agent_prefix "" {
    policy = "write"
  }

  key_prefix "" {
    policy = "write"
  }

  namespace_prefix "" {
    policy = "write"

    # grant service:read for all services in all namespaces
    service_prefix "" {
      policy = "read"
    }

    # grant node:read for all nodes in all namespaces
    node_prefix "" {
      policy = "read"
    }
  }

  node_prefix "" {
    policy = "write"
  }

  mesh = "write"

  peering = "write"

  service_prefix "" {
    policy = "write"
    intentions = "write"
  }

  session_prefix "" {
    policy = "write"
  }
}
