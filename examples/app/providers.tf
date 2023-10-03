provider "hcp" {
  project_id = "FILL THIS IN"
}

provider "consul" {
  address = local.base_outputs.consul_public_url
  scheme  = "https"
  token   = local.base_outputs.consul_root_token_secret_id
}


provider "aws" {
  region = "ap-southeast-1"

  # ...forbidden_account_ids =
}

provider "aws" {
  alias = "a"

  region = "ap-southeast-1"

  # ...
}

provider "aws" {
  alias = "b"

  region = "ap-southeast-1"

  # ...
}

provider "kubernetes" {
  alias = "a"

  host                   = data.aws_eks_cluster.a.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.a.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.a.token
}

provider "kubernetes" {
  alias = "b"

  host                   = data.aws_eks_cluster.b.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.b.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.b.token
}

provider "vault" {
  address = nonsensitive(local.base_outputs.vault_public_endpoint_url)
  token   = hcp_vault_cluster_admin_token.this.token

  namespace = "admin"
}
