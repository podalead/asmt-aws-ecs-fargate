provider "aws" {
  region = var.aws_cred["aws_location"]
  access_key = var.aws_cred["aws_access_key"]
  secret_key = var.aws_cred["aws_secret_key"]
}