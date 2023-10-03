resource "hcp_vault_cluster" "this" {
  cluster_id = var.vault_cluster_id
  hvn_id     = hcp_hvn.this.hvn_id

  tier            = "dev"
  public_endpoint = true
}
