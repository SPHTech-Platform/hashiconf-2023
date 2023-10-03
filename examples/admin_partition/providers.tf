provider "aws" {
  region = "ap-southeast-1"

  # ...
}

provider "aws" {
  alias = "tgw"

  region = "ap-southeast-1"

  # ...
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

provider "helm" {
  alias = "a"

  kubernetes {
    host                   = data.aws_eks_cluster.a.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.a.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.a.token
  }
}

provider "kubernetes" {
  alias = "b"

  host                   = data.aws_eks_cluster.b.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.b.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.b.token
}

provider "helm" {
  alias = "b"

  kubernetes {
    host                   = data.aws_eks_cluster.b.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.b.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.b.token
  }
}

provider "consul" {
  address = local.base_outputs.consul_public_url
  scheme  = "https"
  token   = local.base_outputs.consul_root_token_secret_id
}
