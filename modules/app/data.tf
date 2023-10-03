data "aws_caller_identity" "a" {
  provider = aws.a
}

data "aws_caller_identity" "b" {
  provider = aws.b
}
