provider "hcp" {
  project_id = "FILL THIS IN" # hashiconf
}

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
