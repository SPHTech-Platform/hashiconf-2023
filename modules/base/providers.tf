# Added to satisfy terraform_validate pre-commit hook
provider "aws" {
  alias = "tgw"
}

provider "aws" {
  alias = "a"
}

provider "aws" {
  alias = "b"
}
