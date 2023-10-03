resource "hcp_consul_cluster" "this" {
  cluster_id = var.consul_cluster_id
  hvn_id     = hcp_hvn.this.hvn_id
  datacenter = coalesce(var.consul_datacenter, var.consul_cluster_id)

  tier               = var.consul_tier
  size               = var.consul_size
  min_consul_version = var.min_consul_version

  public_endpoint = var.consul_public_endpoint
}
