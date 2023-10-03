resource "hcp_vault_cluster_admin_token" "this" {
  cluster_id = nonsensitive(local.base_outputs.vault_cluster_id)
}
