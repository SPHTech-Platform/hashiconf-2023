# Added to satisfy terraform_validate pre-commit hook
provider "aws" {
  alias = "a"
}

provider "aws" {
  alias = "b"
}

provider "kubernetes" {
  alias = "a"
}

provider "kubernetes" {
  alias = "b"
}
